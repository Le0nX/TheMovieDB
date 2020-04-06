//
//  TMDBAPIClientTest.swift
//  TMDBNetworkTests
//
//  Created by Denis Nefedov on 25.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

@testable import TMDBNetwork
import XCTest

final class TMDBAPIClientTest: XCTestCase {

    /// make System Under Test
    private func makeSUT(url: String, file: StaticString = #file, line: UInt = #line) -> APIClient {
        let config = APIClientConfig(base: url)
        let client = TMDBAPIClient(config: config)
        trackForMemoryLeaks(client, file: file, line: line)
        
        return client
    }
}
