//
//  GifDataService.swift
//  Goophy
//
//  Created by Vadim Shalugin on 28.03.2022.
//

import Combine
import Foundation

final class GifDataService: GifProvider {
    
    private enum Constants {
        static let token: String = "XnCTUKHtVWAjWLaceyk1WG9IGBvcOY0B"
        static let gifsPerPage: Int = 100
    }
    private var anyCancellable = Set<AnyCancellable>()

    enum GifCatergory: String {
        case trending
        case celebrities
        case cats
        
        init?(from tag: Int) {
            switch tag {
            case 0:
                self = .trending
            case 1:
                self = .cats
            case 2:
                self = .celebrities
            default:
                return nil
            }
        }
        
        var url: String {
            switch self {
            case .trending:
                return "https://api.giphy.com/v1/gifs/trending?api_key=\(Constants.token)"
            case .cats, .celebrities:
                return "https://api.giphy.com/v1/gifs/search?api_key=\(Constants.token)&q=\(self.rawValue)"
            }
        }
    }
    
    var currentOffset = 0
        
    func fetchGifs(for category: GifCatergory) -> AnyPublisher<GifResponse, Error> {
        guard
            let url = URL(string: category.url + "&limit=\(Constants.gifsPerPage)&offset=\(currentOffset)")
        else {
            return Fail(error: APIError.invalidRequestError("URL invalid")).eraseToAnyPublisher()
        }
        var request = requestFromUrl(url: url)
        request.httpMethod = "GET"
        return sendRequest(request: request)
    }
    
    func setOffset(to number: Int) {
        currentOffset = number
    }
    
    func increaseOffset() {
        currentOffset += Constants.gifsPerPage
    }
}
