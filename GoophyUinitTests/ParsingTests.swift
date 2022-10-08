//
//  ParsingTests.swift
//  GoophyUinitTests
//
//  Created by Vadim Shalugin on 06.04.2022.
//

import XCTest

class ParsingTests: XCTestCase {
    
    let fakeDataArray: [String: Any] = [
        "data": [
            "images": [
                "downsized_medium": [
                    "url": "https://media1.giphy.com/media/U94HFTvYzI8yceDhLA/giphy.gif?cid=856b37e5ykzpn12j52yczoe79anirkwuyxtki29h3xte6cju&rid=giphy.gif&ct=g",
                    "height": "480",
                    "width": "480"
                ],
                "downsized": [
                    "url": "https://media1.giphy.com/media/U94HFTvYzI8yceDhLA/giphy.gif?cid=856b37e5ykzpn12j52yczoe79anirkwuyxtki29h3xte6cju&rid=giphy.gif&ct=g",
                    "height": "480",
                    "width": "480"
                ]
            ]
        ],
        "pagination": [
            "total_count" : 3659,
            "count" : 50,
            "offset" : 0
        ]
    ]

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testParsingGifsModel() throws {
        let fakeData = try JSONSerialization.data(withJSONObject: fakeDataArray, options: .prettyPrinted)
        
        let urlString = "https://api.giphy.com/v1/gifs/trending?api_key=\(GifDataService.token)"
        guard let url = URL(string: urlString) else {
            XCTFail("Error: gif url not correct")
            return
        }
        
        let stubbedResponse = HTTPURLResponse(
          url: url,
          statusCode: 200,
          httpVersion: nil,
          headerFields: nil)
    }

}
