//
//  GifProvider.swift
//  Goophy
//
//  Created by Vadim Shalugin on 28.03.2022.
//

import Foundation

class GifProvider {
    
    var baseGifUrl: String = "https://api.giphy.com/v1/gifs/trending"
    let token: String = "XnCTUKHtVWAjWLaceyk1WG9IGBvcOY0B"
    let gifsPerPage: Int = 100
    
    
    struct FailedResponse: Codable {
        let message: String?

        init(from error: Error) {
            let nsError = error as NSError
            self.message = nsError.localizedDescription
        }
    }
    
    func requestFromUrl(url: URL) -> URLRequest {
        return URLRequest(url: url)
    }
    
    func sendRequest<T: Codable>(request: URLRequest, completionHandler: @escaping (T?, FailedResponse?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completionHandler(nil, error != nil ? FailedResponse(from: error!) : nil)
                }
                return
            }

            let decoder = JSONDecoder()
            var failed: GifProvider.FailedResponse?
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                failed = try? decoder.decode(FailedResponse.self, from: data)
                if failed?.message == nil {
                    failed = nil
                }
            }

            var decodedData: T?
            do {
                decodedData = try decoder.decode(T.self, from: data)
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context) {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
            
            DispatchQueue.main.async {
                completionHandler(decodedData, failed)
            }
        }
        task.resume()
    }
}
