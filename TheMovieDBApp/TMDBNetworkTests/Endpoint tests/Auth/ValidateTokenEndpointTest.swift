//
//  ValidateTokenEndpointTest.swift
//  TMDBNetworkTests
//
//  Created by Denis Nefedov on 25.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

@testable import TMDBNetwork
import XCTest

final class ValidateTokenEndpointTest: XCTestCase {
    
    func test_wrongPath() throws {
        let login = "login"
        let passwd = "passwd"
        let token = "token"
        let request = try makeSUT(with: login, password: passwd, requestToken: token)
        
        XCTAssertFalse(request.url?.absoluteString.hasPrefix("/3/authentication/token_x/validate_with_login?") ?? false)
    }
    
    func test_rightPath() throws {
        let login = "login"
        let passwd = "passwd"
        let token = "token"
        let request = try makeSUT(with: login, password: passwd, requestToken: token)
        
        XCTAssertTrue(request.url?.absoluteString.hasPrefix("/3/authentication/token/validate_with_login?") ?? false)
    }
    
    func test_badQueryItems() throws {
        let login = "login"
        let passwd = "passwd"
        let token = "token"
        let request = try makeSUT(with: login, password: passwd, requestToken: token)
        
        XCTAssertNil(request.url?.components?.queryItems?["wrong_api_key"])
        XCTAssertNotEqual(request.url?.components?.queryItems?["api_key"], "wrong_api_key")
    }
    
    func test_rightQueryItems() throws {
        let login = "mylogin"
        let passwd = "mypasswd"
        let token = "mytoken"
        let request = try makeSUT(with: login, password: passwd, requestToken: token)
        
        XCTAssertEqual(request.url?.components?.queryItems?["api_key"], Constant.key)
        XCTAssertEqual(request.url?.components?.queryItems?["language"], Constant.locale)
    }
    
    func test_jsonParameters() throws {
        let login = "login"
        let passwd = "passwd"
        let token = "token"
        let request = try makeSUT(with: login, password: passwd, requestToken: token)
         
        let data = try JSONSerialization.jsonObject(with: request.httpBody!)
        if let data = data as? [String: String] {
            XCTAssertEqual(data["password"], passwd)
            XCTAssertEqual(data["request_token"], token)
            XCTAssertEqual(data["username"], login)
        } else {
            XCTFail("Не смогли распарсить закодированный JSON")
        }
    }

    func test_makeRequest() throws {
        let login = "login"
        let passwd = "passwd"
        let token = "token"
        let request = try makeSUT(with: login, password: passwd, requestToken: token)
        
        assertPost(request: request)
        XCTAssertEqual(request.url?.absoluteString, """
                                                    /3/authentication/token/validate_with_login?\
                                                    api_key=\(Constant.key)&language=\
                                                    \(Constant.locale)
                                                    """)
    }
    
    /// make System Under Test
    /// - Parameter searchItem: параметр поиска
    private func makeSUT(with login: String, password: String, requestToken: String) throws -> URLRequest {
            
        let endpoint = ValidateTokenEndpoint(with: login, password: password, requestToken: requestToken)
        let request = try endpoint.makeRequest()
        
        return request
    }
}
