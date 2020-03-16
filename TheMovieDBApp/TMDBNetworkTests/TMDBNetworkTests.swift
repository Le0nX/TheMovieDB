//
//  TMDBNetworkTests.swift
//  TMDBNetworkTests
//
//  Created by Denis Nefedov on 17.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

@testable import TMDBNetwork
import XCTest

class TMDBNetworkTests: XCTestCase {

    func test_CreateSuccessRequestToken() {
        let client = TMDBAPIClient()
        let endpoint = RequestTokenEndpoint()
        
        client.request(endpoint) { result in
            switch result {
            case .success(let tokenRequest):
                XCTAssertTrue(tokenRequest.success)
            case .failure:
                XCTFail("Couldn't get token")
            }
        }
        
    }
    
    func test_ValidateRequestToken() {
        let client = TMDBAPIClient()
        let endpoint = RequestTokenEndpoint()
        var token = ""
        
        client.request(endpoint) { result in
            switch result {
            case .success(let tokenRequest):
                token = tokenRequest.requestToken
            case .failure:
                XCTFail("Couldn't get token")
            }
        }
        
        let endpoint2 = ValidateTokenEndpoint(with: "le0nx", password: "Qwerty123", requestToken: token)
        
        client.request(endpoint2) { result in
            switch result {
            case .success(let validation):
                XCTAssertTrue(validation.success)
            case .failure:
                XCTFail("Couldn't validate token")
            }
        }
    }
    
    func test_SessionRequest() {
        let client = TMDBAPIClient()
        let endpoint = RequestTokenEndpoint()
        var token = ""
        
        client.request(endpoint) { result in
            switch result {
            case .success(let tokenRequest):
                token = tokenRequest.requestToken
            case .failure:
                XCTFail("Couldn't get token")
            }
        }
        
        let endpoint2 = ValidateTokenEndpoint(with: "le0nx", password: "Qwerty123", requestToken: token)
        
        client.request(endpoint2) { result in
            switch result {
            case .success(let validation):
                token = validation.requestToken
            case .failure:
                XCTFail("Couldn't validate token")
            }
        }
        
        let endpoint3 = SessionEndpoint(with: token)
        
        client.request(endpoint3) { result in
            switch result {
            case .success(let session):
                XCTAssertTrue(session.success)
            case .failure:
                XCTFail("Couldn't create session")
            }
        }
    }
    
    func test_searchMovie() {
        let client = TMDBAPIClient()
        let endpoint = SearchEndpoint(search: "007")
        
        client.request(endpoint) { result in
            switch result {
            case .success(let movieResponse):
                print(movieResponse.results)
                XCTAssertTrue(movieResponse.totalResults ?? 0 > 0)
            case .failure:
                XCTFail("Couldn't find film")
            }
        }
        
    }
    
}
