//
//  SessionEndpointTest.swift
//  TMDBNetworkTests
//
//  Created by Denis Nefedov on 25.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

@testable import TMDBNetwork
import XCTest

final class SessionEndpointTest: XCTestCase {
    
    func test_wrongPath() throws {
        let token = "token"
        let request = try makeSUT(with: token)
        
        XCTAssertFalse(request.url?.absoluteString.hasPrefix("/3/authentication/session_bad/new?") ?? false)
    }
    
    func test_rightPath() throws {
        let token = "token"
        let request = try makeSUT(with: token)
        
        XCTAssertTrue(request.url?.absoluteString.hasPrefix("/3/authentication/session/new?") ?? false)
    }
    
    func test_badQueryItems() throws {
        let token = "token"
        let request = try makeSUT(with: token)
        
        XCTAssertNil(request.url?.components?.queryItems?["wrong_api_key"])
        XCTAssertNotEqual(request.url?.components?.queryItems?["api_key"], "wrong_api_key")
    }
    
    func test_rightQueryItems() throws {
        let token = "mytoken"
        let request = try makeSUT(with: token)
        
        XCTAssertEqual(request.url?.components?.queryItems?["api_key"], Constant.key)
        XCTAssertEqual(request.url?.components?.queryItems?["language"], Constant.locale)
    }
    
    func test_jsonParameters() throws {
        let token = "token"
        let request = try makeSUT(with: token)
         
        let data = try JSONSerialization.jsonObject(with: request.httpBody!)
        if let data = data as? [String: String] {
            XCTAssertEqual(data["request_token"], token)
        } else {
            XCTFail("Не смогли распарсить закодированный JSON")
        }
    }

    func test_makeRequest() throws {
        let token = "token"
        let request = try makeSUT(with: token)
        
        assertPost(request: request)
        XCTAssertEqual(request.url?.absoluteString, """
                                                    /3/authentication/session/new?\
                                                    api_key=\(Constant.key)&language=\
                                                    \(Constant.locale)
                                                    """)
    }
    
    /// make System Under Test
    /// - Parameter searchItem: параметр поиска
    private func makeSUT(with validataionToken: String) throws -> URLRequest {
            
        let endpoint = SessionEndpoint(with: validataionToken)
        let request = try endpoint.makeRequest()
        
        return request
    }
}
