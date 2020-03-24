//
//  PosterEnpointTest.swift
//  TMDBNetworkTests
//
//  Created by Denis Nefedov on 24.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

@testable import TMDBNetwork
import XCTest

final class PosterEndpointTest: XCTestCase {
    
    func test_badQueryItems() throws {
        let searchItem = "test"
        let request = try makeSUT(with: searchItem)
        
        XCTAssertNil(request.url?.components?.queryItems?["wrong_api_key"])
        XCTAssertNotEqual(request.url?.components?.queryItems?["api_key"], "wrong_api_key")
    }
    
    func test_rightQueryItems() throws {
        let searchItem = "test"
        let request = try makeSUT(with: searchItem)
        
        XCTAssertEqual(request.url?.components?.queryItems?["api_key"], Constant.key)
        XCTAssertEqual(request.url?.components?.queryItems?["language"], Constant.locale)
    }
    
    func test_wrongPath() throws {
        let searchItem = "test"
        let request = try makeSUT(with: searchItem)
        
        XCTAssertFalse(request.url?.absoluteString.hasPrefix("/t/p/w185//worong_test") ?? false)
    }
    
    func test_rightPath() throws {
        let searchItem = "test"
        let request = try makeSUT(with: searchItem)
        
        XCTAssertTrue(request.url?.absoluteString.hasPrefix("/t/p/w185//test") ?? false)
    }

    func test_makeRequest() throws {
        let searchItem = "test"
        let request = try makeSUT(with: searchItem)
        
        assertGet(request: request)
        XCTAssertEqual(request.url?.absoluteString,
                       "/t/p/w185//\(searchItem)?api_key=\(Constant.key)&language=\(Constant.locale)")
    }
    
    /// make System Under Test
    /// - Parameter searchItem: параметр поиска
    private func makeSUT(with searchItem: String, file: StaticString = #file, line: UInt = #line) throws -> URLRequest {
            
        let endpoint = PosterEndpoint(poster: searchItem)
        let request = try endpoint.makeRequest()
        
        return request
    }
}
