//
//  GifResponse.swift
//  Goophy
//
//  Created by Vadim Shalugin on 28.03.2022.
//

import AVKit
import Foundation

public typealias Gif = GifResponse.GifObject.Image
typealias GifCategory = GifDataService.GifCatergory

enum GifFetchResult {
    case success([Gif])
    case error(String)
}

public struct GifResponse: Codable {
    let data: [GifObject]

    public struct GifObject: Codable {
        let images: Image

        public struct Image: Codable {
            let original: Data
            let downsized: Data
            
            enum CodingKeys: String, CodingKey {
                case original = "downsized_medium"
                case downsized = "downsized"
            }

            struct Data: Codable {
                let url: String?
                var height: String?
                var width: String?

                var videoURL: URL? {
                    URL(string: url ?? "")
                }
            }
        }
    }
    
}
