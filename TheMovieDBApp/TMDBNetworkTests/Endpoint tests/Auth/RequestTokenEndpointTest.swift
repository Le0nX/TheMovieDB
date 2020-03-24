//
//  RequestTokenEndpointTest.swift
//  TMDBNetworkTests
//
//  Created by Denis Nefedov on 25.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

@testable import TMDBNetwork
import XCTest

final class RequestTokenEndpointTest: XCTestCase {
    
    func test_wrongPath() throws {
        let request = try makeSUT()
        
        XCTAssertFalse(request.url?.absoluteString.hasPrefix("/3/authentication/bad_token/new?") ?? false)
    }
    
    func test_rightPath() throws {
        let request = try makeSUT()
        
        XCTAssertTrue(request.url?.absoluteString.hasPrefix("/3/authentication/token/new?") ?? false)
    }
    
    func test_badQueryItems() throws {
        let request = try makeSUT()
        
        XCTAssertNil(request.url?.components?.queryItems?["wrong_api_key"])
        XCTAssertNotEqual(request.url?.components?.queryItems?["api_key"], "wrong_api_key")
    }
    
    func test_rightQueryItems() throws {
        let request = try makeSUT()
        
        XCTAssertEqual(request.url?.components?.queryItems?["api_key"], Constant.key)
        XCTAssertEqual(request.url?.components?.queryItems?["language"], Constant.locale)
    }

    func test_makeRequest() throws {
        let request = try makeSUT()
        
        assertGet(request: request)
        XCTAssertEqual(request.url?.absoluteString, """
                                                    /3/authentication/token/new?api_key=\
                                                    \(Constant.key)&language=\(Constant.locale)
                                                    """)
    }
    
    /// make System Under Test
    /// - Parameter searchItem: параметр поиска
    private func makeSUT() throws -> URLRequest {
            
        let endpoint = RequestTokenEndpoint()
        let request = try endpoint.makeRequest()
        
        return request
    }
}
