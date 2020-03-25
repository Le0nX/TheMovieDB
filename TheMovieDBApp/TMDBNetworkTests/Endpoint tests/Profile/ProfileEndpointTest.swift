//
//  ProfileEndpointTest.swift
//  TMDBNetworkTests
//
//  Created by Denis Nefedov on 24.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

@testable import TMDBNetwork
import XCTest

final class ProfileEndpointTest: XCTestCase {
    
    func test_wrongPath() throws {
        let searchItem = "session_id"
        let request = try makeSUT(with: searchItem)
        
        XCTAssertFalse(request.url?.absoluteString.hasPrefix("/3/account_wrong?") ?? false)
    }
    
    func test_rightPath() throws {
        let searchItem = "session_id"
        let request = try makeSUT(with: searchItem)
        
        XCTAssertTrue(request.url?.absoluteString.hasPrefix("/3/account?") ?? false)
    }
    
    func test_badQueryItems() throws {
        let searchItem = "session_id"
        let request = try makeSUT(with: searchItem)
        
        XCTAssertNil(request.url?.components?.queryItems?["wrong_api_key"])
        XCTAssertNotEqual(request.url?.components?.queryItems?["api_key"], "wrong_api_key")
        XCTAssertNotEqual(request.url?.components?.queryItems?["session_id"], "wrong_session_id")
    }
    
    func test_rightQueryItems() throws {
        let searchItem = "right_session_id"
        let request = try makeSUT(with: searchItem)
        
        XCTAssertEqual(request.url?.components?.queryItems?["api_key"], Constant.key)
        XCTAssertEqual(request.url?.components?.queryItems?["language"], Constant.locale)
        XCTAssertEqual(request.url?.components?.queryItems?["session_id"], searchItem)
    }

    func test_makeRequest() throws {
        let searchItem = "right_session_id"
        let request = try makeSUT(with: searchItem)
        
        assertGet(request: request)
        XCTAssertEqual(request.url?.absoluteString, """
                                                    /3/account?api_key=\(Constant.key)&language=\
                                                    \(Constant.locale)&session_id=
                                                    """+searchItem)
    }
    
    func test_emptyResponse() throws {
        let session = "right_session_id"
        let endpoint = ProfileEndpoint(sessionId: session)
        let response = URLResponse()
                
        XCTAssertThrowsError(try endpoint.content(from: Data(), response: response))
    }
    
    /// make System Under Test
    /// - Parameter searchItem: параметр поиска
    private func makeSUT(with searchItem: String) throws -> URLRequest {
            
        let endpoint = ProfileEndpoint(sessionId: searchItem)
        let request = try endpoint.makeRequest()
        
        return request
    }
}
