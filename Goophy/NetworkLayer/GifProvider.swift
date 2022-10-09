//
//  GifProvider.swift
//  Goophy
//
//  Created by Vadim Shalugin on 28.03.2022.
//

import Combine
import Foundation

class GifProvider {
    
    enum APIError: LocalizedError {
        /// Invalid request, e.g. invalid URL
        case invalidRequestError(String)
        /// Indicates an error on the transport layer, e.g. not being able to connect to the server
        case transportError(Error)
        /// Received an invalid response, e.g. non-HTTP result
        case invalidResponse
        /// Server-side validation error
        case validationError(String)
        /// The server sent data in an unexpected format
        case decodingError(Error)

        var errorDescription: String? {
            switch self {
            case .invalidRequestError(let message):
                return "Invalid request: \(message)"
            case .transportError(let error):
                return "Transport error: \(error)"
            case .invalidResponse:
                return "Invalid response"
            case .validationError(let reason):
                return "Validation Error: \(reason)"
            case .decodingError:
                return "The server returned data in an unexpected format."
            }
        }
    }
    
    struct APIErrorMessage: Decodable {
        let meta: Meta
        
        struct Meta: Codable {
            let msg: String
        }
    }
    
    func requestFromUrl(url: URL) -> URLRequest {
        return URLRequest(url: url)
    }
    
    func sendRequest<Response>(_ request: URLRequest) -> AnyPublisher<Response, Error> where Response: Codable {
        URLSession.shared
            .dataTaskPublisher(for: request)
            .mapError { error in
                return APIError.transportError(error)
            }
            .tryMap { (data, response) -> (data: Data, response: URLResponse) in
                guard let urlResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                guard (200..<300) ~= urlResponse.statusCode else {
                    let decoder = JSONDecoder()
                    let apiError = try decoder.decode(APIErrorMessage.self, from: data)
                    throw APIError.validationError(apiError.meta.msg)
                }
                return (data, response)
            }
            .map(\.data)
            .tryMap { data -> Response in
                let decoder = JSONDecoder()
                do {
                    return try decoder.decode(Response.self, from: data)
                } catch {
                    throw APIError.decodingError(error)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
