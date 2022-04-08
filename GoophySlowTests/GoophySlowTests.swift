//
//  GoophySlowTests.swift
//  GoophySlowTests
//
//  Created by Vadim Shalugin on 06.04.2022.
//

import XCTest
@testable import Goophy

class GoophySlowTests: XCTestCase {
    
    var dataService: GifDataService!
    var session: URLSession!

    override func setUpWithError() throws {
        try super.setUpWithError()
        dataService = GifDataService()
        session = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
        dataService = nil
        session = nil
        try super.tearDownWithError()
    }
    
    func testGifFetch() throws {

        let promise = expectation(description: "No gifs fetched")
        
        dataService.fetchGifs(for: .trending) { response, failed in
            if let error = failed {
                XCTFail("Error: \(error.message ?? "No error message")")
            } else if let _ = response {
                promise.fulfill()
            }
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    func testApiCall() throws {

        let urlString = "https://api.giphy.com/v1/gifs/trending?api_key=\(GifDataService.token)"
        var statusCode: Int?
        var responseError: Error?
        
        guard let url = URL(string: urlString) else {
            XCTFail("Error: gif url not correct")
            return
        }
        
        let promise = expectation(description: "Status code 200")
        
        let dataTask = session.dataTask(with: url) { _, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        
        wait(for: [promise], timeout: 5)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200, "Всё пропало, капитан!")
    }

}
