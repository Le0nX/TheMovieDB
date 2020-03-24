//
//  URLBuilderTest.swift
//  TMDBNetworkTests
//
//  Created by Denis Nefedov on 25.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

@testable import TMDBNetwork
import XCTest

class URLBuilderTest: XCTestCase {

    func test_builderPath() throws {
        let builder = makeSUT()
        
        let request = try builder.build(for: "test", method: .get)
        XCTAssertFalse(request.url?.absoluteString.hasPrefix("tset") ?? false)
        XCTAssertTrue(request.url?.absoluteString.hasPrefix("test") ?? false)
        
    }
    
    func test_builderParams() throws {
        let params = ["first": "firstValue", "second": "secondValue"]
        let builder = makeSUT()
        
        let request = try builder.build(for: "test", method: .get, params: params)
        XCTAssertNil(request.url?.components?.queryItems?["wrong_item"])
        XCTAssertEqual(request.url?.components?.queryItems?["first"], params["first"])
        XCTAssertEqual(request.url?.components?.queryItems?["second"], params["second"])
        XCTAssertNotEqual(request.url?.components?.queryItems?["second"], "secondValueWrong")
    }
    
    func test_builderParamsJsonEncoding() throws {
        let params = ["first": "firstValue", "second": "secondValue"]
        let builder = makeSUT()
        
        let request = try builder.build(for: "test", method: .post, parameterEncoding: .jsonEncoding, params: params)
         
        let data = try JSONSerialization.jsonObject(with: request.httpBody!)
        if let data = data as? [String: String] {
            XCTAssertEqual(data["first"], params["first"])
            XCTAssertEqual(data["second"], params["second"])
        } else {
            XCTFail("Не смогли распарсить закодированный JSON")
        }
    }
    
    func test_builderHeaders() throws {
        let headers = ["first": "firstValue", "second": "secondValue"]
        let builder = makeSUT()
        
        let request = try builder.build(for: "test", method: .get, headers: headers)
         
        let testHeaders = request.allHTTPHeaderFields
        XCTAssertEqual(headers, testHeaders)
    }
    
    /// make System Under Test
    /// - Parameter searchItem: параметр поиска
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> URLBuilder {
            
        let builder = URLBuilder()
        trackForMemoryLeaks(builder, file: file, line: line)
        
        return builder
    }

}
