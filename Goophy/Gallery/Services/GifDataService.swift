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
        case tranding
        case cats
        case celebrities
        
        var url: String {
            switch self {
            case .tranding:
                return "https://api.giphy.com/v1/gifs/trending?api_key=\(token)"
            default:
                return "https://api.giphy.com/v1/gifs/search?api_key=\(token)&q=\(self.rawValue)"
            }
        }
    }
    
    var currentOffset = 0
    
    func fetchGifs(for category: GifCatergory,completionHandler: @escaping (GifResponse?, FailedResponse?) -> Void) {
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
