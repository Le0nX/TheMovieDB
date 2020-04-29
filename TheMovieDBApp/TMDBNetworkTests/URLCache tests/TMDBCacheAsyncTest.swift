//
//  TMDBCacheAsyncTest.swift
//  TMDBNetworkTests
//
//  Created by Denis Nefedov on 29.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import XCTest
import TMDBNetwork

class TMDBCacheAsyncTest: XCTestCase {

    private var cache = TMDBURLCacheAsync()
  
    func testStoreAndRead() {
        let (cachedResponse, task) = makeHelpers()
        cache.storeCachedResponse(cachedResponse, for: task)
        let exp = expectation(description: "Ждем конца загрузки")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.cache.getCachedResponse(for: task) { response in
                XCTAssertEqual(cachedResponse, response)
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 1.0)
    }
  
    func testRemove() {
        let (cachedResponse, task) = makeHelpers()
        cache.storeCachedResponse(cachedResponse, for: task)
        cache.removeCachedResponse(for: task)
        let exp = expectation(description: "Ждем конца загрузки")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.cache.getCachedResponse(for: task) { response in
                XCTAssertNil(response)
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 1.0)
    }
  
    func testConcurrentWork() {
        // если не будет блокировки внутри storeCachedResponse, то код упадет при многопоточном доступе
        let exp = expectation(description: "Ждем конца загрузки")
        exp.expectedFulfillmentCount = 5
        
        DispatchQueue.concurrentPerform(iterations: 5, execute: { count in
            let (cachedResponse, task) = makeHelpers(request: "http://test"+String(count)+".com")
            cache.storeCachedResponse(cachedResponse, for: task)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.cache.getCachedResponse(for: task) { response in
                    XCTAssertEqual(cachedResponse, response)
                    exp.fulfill()
                }
            }
        })
        waitForExpectations(timeout: 1) { error in
          XCTAssertNil(error)
        }
    }
  
    /// Фабрика вспомогательных объектов
    /// - Parameters:
    ///   - request: кастомный реквест
    ///   - dataString: кастомная дата
    private func makeHelpers(request: String = "http://test.com",
                             dataString: String = "test") -> (CachedURLResponse, URLSessionDataTask) {
        let cachedResponse = CachedURLResponse(response: URLResponse(), data: dataString.data(using: .utf8)!)
        let task = URLSession.shared.dataTask(with: URL(string: request)!)
      
        return (cachedResponse, task)
    }

}
