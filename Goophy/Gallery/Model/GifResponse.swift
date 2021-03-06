//
//  GifResponse.swift
//  Goophy
//
//  Created by Vadim Shalugin on 28.03.2022.
//

import AVKit
import Foundation

struct GifResponse: Codable {
    let data: [GifObject]
    let pagination: Pagination

    struct Pagination: Codable {
        let totalCount: Int
        let offset: Int

        enum CodingKeys: String, CodingKey {
            case totalCount = "total_count"
            case offset
        }
    }

    struct GifObject: Codable {
        let images: Image

        struct Image: Codable {
            let original: Data
            let downsized: Data
            
            enum CodingKeys: String, CodingKey {
                case original = "downsized_medium"
                case downsized = "downsized"
            }

            struct Data: Codable {
                let url: String?
                let height: String
                let width: String

                var videoURL: URL? {
                    URL(string: url ?? "")
                }
            }
        }
    }
    
}
