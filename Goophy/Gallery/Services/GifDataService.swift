//
//  GifDataService.swift
//  Goophy
//
//  Created by Vadim Shalugin on 28.03.2022.
//

import Foundation

final class GifDataService: GifProvider {
    
    var currentOffset = 0
    
    func fetchGifs(completionHandler: @escaping (GifResponse?, FailedResponse?) -> Void) {
      guard
          let url = URL(string: baseGifUrl + "?api_key=\(token)&limit=\(gifsPerPage)&offset=\(currentOffset)")
      else {
          return
      }
      var request = requestFromUrl(url: url)
      request.httpMethod = "GET"
      
      sendRequest(request: request, completionHandler: completionHandler)
    }
}
