//
//  FavoriteEndpointTest.swift
//  TMDBNetworkTests
//
//  Created by Denis Nefedov on 25.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

@testable import TMDBNetwork
import XCTest

final class FavoriteEndpointTest: XCTestCase {
    
    func test_wrongPath() throws {
        let sessionId = "session_id"
        let accountId = 1
        let request = try makeSUT(with: sessionId, id: accountId)
        
        XCTAssertFalse(request.url?.absoluteString.hasPrefix("/3/account/\(accountId)/favorite_bad/movies?") ?? false)
    }
    
    func test_rightPath() throws {
        let sessionId = "session_id"
        let accountId = 11
        let request = try makeSUT(with: sessionId, id: accountId)
        
        XCTAssertTrue(request.url?.absoluteString.hasPrefix("/3/account/\(accountId)/favorite/movies?") ?? false)
    }
    
    func test_badQueryItems() throws {
        let sessionId = "session_id"
        let request = try makeSUT(with: sessionId)
        
        XCTAssertNil(request.url?.components?.queryItems?["wrong_api_key"])
        XCTAssertNotEqual(request.url?.components?.queryItems?["api_key"], "wrong_api_key")
        XCTAssertNotEqual(request.url?.components?.queryItems?["session_id"], "wrong_session_id")
        XCTAssertNotEqual(request.url?.components?.queryItems?["page"], "wrong_page")
    }
    
    func test_rightQueryItems() throws {
        let sessionId = "right_session_id"
        let page = 10
        let request = try makeSUT(with: sessionId, page: page )
        
        XCTAssertEqual(request.url?.components?.queryItems?["api_key"], Constant.key)
        XCTAssertEqual(request.url?.components?.queryItems?["language"], Constant.locale)
        XCTAssertEqual(request.url?.components?.queryItems?["session_id"], sessionId)
        XCTAssertEqual(request.url?.components?.queryItems?["page"], String(page))
    }

    func test_makeRequest() throws {
        let sessionId = "right_session_id"
        let accountId = 11
        let page = 12
        let request = try makeSUT(with: sessionId, id: accountId, page: page)
        
        assertGet(request: request)
    }
    
    func test_emptyResponse() throws {
        let endpoint = FavoriteEndpoint(accountId: 1, page: 1, sessionId: "sessionid")
        let response = URLResponse()
                
        XCTAssertThrowsError(try endpoint.content(from: Data(), response: response))
    }
    
    /// make System Under Test
    /// - Parameter searchItem: параметр поиска
    private func makeSUT(with sessionId: String, id: Int = 1, page: Int = 1) throws -> URLRequest {
            
        let endpoint = FavoriteEndpoint(accountId: id, page: page, sessionId: sessionId)
        let request = try endpoint.makeRequest()
        
        return request
    }
}
