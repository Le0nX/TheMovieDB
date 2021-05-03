//
//  TMDBCacheTest.swift
//  TMDBNetworkTests
//
//  Created by Denis Nefedov on 29.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import XCTest
import TMDBNetwork

class TMDBCacheTest: XCTestCase {
    
    private var cache = TMDBURLCache()
    
    func testStoreAndRead() {
        let (cachedResponse, request) = makeHelpers()
        cache.storeCachedResponse(cachedResponse, for: request)
        XCTAssertEqual(cachedResponse, cache.cachedResponse(for: request))
    }
    
    func testRemove() {
        let (cachedResponse, request) = makeHelpers()
        cache.storeCachedResponse(cachedResponse, for: request)
        cache.removeCachedResponse(for: request)
        XCTAssertNil(cache.cachedResponse(for: request))
    }
    
    func testRemoveAll() {
        let (cachedResponse, request) = makeHelpers()
        let (cachedResponse2, request2) = makeHelpers(request: "http://test1.com", dataString: "data")
        cache.storeCachedResponse(cachedResponse, for: request)
        cache.storeCachedResponse(cachedResponse2, for: request2)
        cache.removeAllCachedResponses()
        XCTAssertNil(cache.cachedResponse(for: request))
        XCTAssertNil(cache.cachedResponse(for: request2))
    }
    
    func testConcurrentWork() {
        // если не будет блокировки внутри storeCachedResponse, то код упадет при многопоточном доступе
        DispatchQueue.concurrentPerform(iterations: 5, execute: { count in
            let (cachedResponse, request) = makeHelpers(request: "http://test"+String(count)+".com")
            cache.storeCachedResponse(cachedResponse, for: request)
            XCTAssertEqual(cachedResponse, cache.cachedResponse(for: request))
        })

    }
    
    /// Фабрика вспомогательных объектов
    /// - Parameters:
    ///   - request: кастомный реквест
    ///   - dataString: кастомная дата
    private func makeHelpers(request: String = "http://test.com", dataString: String = "test") -> (CachedURLResponse, URLRequest) {
        let cachedResponse = CachedURLResponse(response: URLResponse(), data: dataString.data(using: .utf8)!)
        let request = URLRequest(url: URL(string: request)!)
        
        return (cachedResponse, request)
    }

}
