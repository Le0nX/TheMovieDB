//
//  SearchFilmEndpointTest.swift
//  TMDBNetworkTests
//
//  Created by Denis Nefedov on 24.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

@testable import TMDBNetwork
import XCTest

final class SearchFilmEndpointTest: XCTestCase {
    
    func test_queryItems() throws {
        let searchText = "test"
        let endpoint = SearchFilmEndpoint(search: searchText)
        
        let request = try endpoint.makeRequest()
        print(request.url?.components ?? "")
        
        XCTAssertEqual(request.url?.components?.queryItems?["api_key"], Constant.key)
        XCTAssertEqual(request.url?.components?.queryItems?["language"], Constant.locale)
        XCTAssertEqual(request.url?.components?.queryItems?["query"], searchText)
    }

    func test_makeRequest() throws {
        let searchText = "test"
        let endpoint = SearchFilmEndpoint(search: searchText)
        
        let request = try endpoint.makeRequest()
        assertGet(request: request)
        XCTAssertEqual(request.url?.absoluteString, """
                                                    /3/search/movie?api_key=\(Constant.key)&language=\
                                                    \(Constant.locale)&query=
                                                    """+searchText)
    }

    private func assertGet(request: URLRequest) {
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertNil(request.httpBody)
    }
}
