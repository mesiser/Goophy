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
    }
        
    struct FailedResponse: Codable, Error {
        let message: String?

        init(from error: Error) {
            let nsError = error as NSError
            self.message = nsError.localizedDescription
        }
    }
    
    func requestFromUrl(url: URL) -> URLRequest {
        return URLRequest(url: url)
    }
    
    func sendRequest<Response>(request: URLRequest) -> AnyPublisher<Response, Error> where Response: Codable {
        URLSession.shared
            .dataTaskPublisher(for: request)
                .tryMap() { element in
                    guard let httpResponse = element.response as? HTTPURLResponse,
                        httpResponse.statusCode == 200 else {
                            throw URLError(.badServerResponse)
                        }
                    return element.data
                }
                .decode(type: Response.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
    }
    
    private func log(_ data: Data) {
        
        #if DEBUG
        if let utf8Text = data.prettyPrintedJSONString {
            print("\(utf8Text)\n")
        }
        #endif
    }
}
