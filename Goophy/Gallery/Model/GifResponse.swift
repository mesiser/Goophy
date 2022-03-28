//
//  GifResponse.swift
//  Goophy
//
//  Created by Vadim Shalugin on 28.03.2022.
//

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
            let original: Original

            struct Original: Codable {
                let mp4: String
                let height: String
                let width: String

                var videoURL: URL? {
                  URL(string: mp4)
                }
            }
        }
    }
    
}
