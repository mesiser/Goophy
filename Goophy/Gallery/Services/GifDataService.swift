//
//  GifDataService.swift
//  Goophy
//
//  Created by Vadim Shalugin on 28.03.2022.
//

import Foundation

final class GifDataService: GifProvider {
    
    static let token: String = "XnCTUKHtVWAjWLaceyk1WG9IGBvcOY0B"
    
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
                return "https://api.giphy.com/v1/gifs/trending?api_key=\(token)"
            case .cats, .celebrities:
                return "https://api.giphy.com/v1/gifs/search?api_key=\(token)&q=\(self.rawValue)"
            }
        }
    }
    
    var currentOffset = 0
    
    func fetchGifs(for category: GifCatergory, completionHandler: @escaping (GifResponse?, FailedResponse?) -> Void) {
        guard
            let url = URL(string: category.url + "&limit=\(gifsPerPage)&offset=\(currentOffset)")
        else {
            return
        }
        var request = requestFromUrl(url: url)
        request.httpMethod = "GET"

        sendRequest(request: request, completionHandler: completionHandler)
    }
}
