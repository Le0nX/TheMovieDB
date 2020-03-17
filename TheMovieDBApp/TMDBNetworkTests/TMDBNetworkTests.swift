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
        var token: RequestToken?
        
        let exp = expectation(description: "Check token was created successfully")
        
        client.request(endpoint) { result in
            switch result {
            case .success(let tokenRequest):
                token = tokenRequest
                exp.fulfill()
            case .failure:
                XCTFail("Couldn't get token")
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            XCTAssertTrue(token?.success ?? false)
        }
        
    }
    
    func test_ValidateRequestToken() {
        let client = TMDBAPIClient()
        let endpoint = RequestTokenEndpoint()
        var token = ""
        
        let exp = expectation(description: "Check token was created successfully")
        
        client.request(endpoint) { result in
            switch result {
            case .success(let tokenRequest):
                token = tokenRequest.requestToken
                exp.fulfill()
            case .failure:
                XCTFail("Couldn't get token")
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
        let exp1 = expectation(description: "Check validationToken was created successfully")
        
        let endpoint2 = ValidateTokenEndpoint(with: "le0nx", password: "Qwerty123", requestToken: token)
        var validationToken: ValidateToken?
        
        client.request(endpoint2) { result in
            switch result {
            case .success(let validation):
                validationToken = validation
                exp1.fulfill()
            case .failure:
                XCTFail("Couldn't validate token")
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            XCTAssertTrue(validationToken?.success ?? false)
        }
    }
    
    func test_SessionRequest() {
        let client = TMDBAPIClient()
        let endpoint = RequestTokenEndpoint()
        var token = ""
        
        let exp = expectation(description: "Check token was created successfully")
        
        client.request(endpoint) { result in
            switch result {
            case .success(let tokenRequest):
                token = tokenRequest.requestToken
                exp.fulfill()
            case .failure:
                XCTFail("Couldn't get token")
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
        let exp1 = expectation(description: "Check validationToken was created successfully")
        
        let endpoint2 = ValidateTokenEndpoint(with: "le0nx", password: "Qwerty123", requestToken: token)
        var validationToken: ValidateToken?
        
        client.request(endpoint2) { result in
            switch result {
            case .success(let validation):
                validationToken = validation
                exp1.fulfill()
            case .failure:
                XCTFail("Couldn't validate token")
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }

        let exp2 = expectation(description: "Check session was created successfully")
        let endpoint3 = SessionEndpoint(with: validationToken?.requestToken ?? "")
        var sessionRequest: UserSession?

        client.request(endpoint3) { result in
            switch result {
            case .success(let session):
                sessionRequest = session
                exp2.fulfill()
            case .failure:
                XCTFail("Couldn't create session")
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            XCTAssertTrue(sessionRequest?.success ?? false)
        }
    }

    func test_searchMovie() {
        let client = TMDBAPIClient()
        let endpoint = SearchEndpoint(search: "007")

        let exp = expectation(description: "Check moview were found successfully")
        var movies: MovieResponse?
        
        client.request(endpoint) { result in
            switch result {
            case .success(let movieResponse):
                movies = movieResponse
                exp.fulfill()
            case .failure:
                XCTFail("Couldn't find film")
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            XCTAssertTrue(movies?.totalResults ?? 0 > 0)
        }
    }

    func test_getFavorites() {
        let client = TMDBAPIClient()
        let session = makeSessionHelper()

        let endpoint = FavoriteEndpoint(accountId: 000, page: 1, sessionId: session)
        var favorites: MovieResponse?
        let exp = expectation(description: "Check favorites were found successfully")
        
        client.request(endpoint) { result in
            switch result {
            case .success(let movieResponse):
                favorites = movieResponse
                exp.fulfill()
            case .failure:
                XCTFail("Couldn't find film")
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            XCTAssertTrue(favorites?.totalResults ?? 0 > 0)
        }

    }

    private func makeSessionHelper() -> String {
        let client = TMDBAPIClient()
        let endpoint = RequestTokenEndpoint()
        var token = ""
        
        let exp = expectation(description: "Check token was created successfully")
        
        client.request(endpoint) { result in
            switch result {
            case .success(let tokenRequest):
                token = tokenRequest.requestToken
                exp.fulfill()
            case .failure:
                XCTFail("Couldn't get token")
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
        let exp1 = expectation(description: "Check validationToken was created successfully")
        
        let endpoint2 = ValidateTokenEndpoint(with: "le0nx", password: "Qwerty123", requestToken: token)
        var validationToken: ValidateToken?
        
        client.request(endpoint2) { result in
            switch result {
            case .success(let validation):
                validationToken = validation
                exp1.fulfill()
            case .failure:
                XCTFail("Couldn't validate token")
            }
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        let exp2 = expectation(description: "Check session was created successfully")
        let endpoint3 = SessionEndpoint(with: validationToken?.requestToken ?? "")
        var sessionRequest: UserSession?

        client.request(endpoint3) { result in
            switch result {
            case .success(let session):
                sessionRequest = session
                exp2.fulfill()
            case .failure:
                XCTFail("Couldn't create session")
            }
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        return sessionRequest?.sessionId ?? ""
    }
    
}
