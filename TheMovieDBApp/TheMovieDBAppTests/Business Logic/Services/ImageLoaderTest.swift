//
//  ImageLoaderTest.swift
//  TheMovieDBAppTests
//
//  Created by Denis Nefedov on 06.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import TheMovieDBApp
import TMDBNetwork
import XCTest

class ImageLoaderTest: XCTestCase {
    
    /// Проверка на то, что два вызова подряд будут в правильном кол-ве и порядке
    func test_twicePosterSearchCall() {
        
        let (client, service) = makeSUT()
        
        let film1 = "film1"
        let film2 = "film2"
        
        _ = service.fetchImage(for: film1) { _ in }
        _ = service.fetchImage(for: film2) { _ in }
        
        let endpoint = PosterEndpoint(poster: film1)
        let endpoint2 = PosterEndpoint(poster: film2)
        
        XCTAssertEqual(client.urlRequests, [try? endpoint.makeRequest(), try? endpoint2.makeRequest()])
    }

    func test_onPosterResultsDataAndCancell() {
        let (client, service) = makeSUT()
        let search = "poster"
        let endpoint = PosterEndpoint(poster: search)
        
        expectSearchPoster(service, toCompleteWith: Data(), when: {
            client.complete(for: endpoint, with: Data())
        })
    }
    
    // MARK: - Private helpers
    
    /// make System Under Test
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (APIClientSpy, ImageLoader) {
        let client = APIClientSpy()
        let service = ServiceFabric().imageLoader()
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(service, file: file, line: line)
        
        return (client, service)
    }

    @discardableResult
    private func expectSearchPoster(_ sut: ImageLoader,
                                    toCompleteWith expectedResult: Data?,
                                    when action: () -> Void,
                                    file: StaticString = #file,
                                    line: UInt = #line) -> UUID? {
            
        let exp = expectation(description: "Ждем конца загрузки")
        
        let uuid = sut.fetchImage(for: name) { receivedResult in
    
            XCTAssertEqual(receivedResult, expectedResult, file: file, line: line)
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
        return uuid
    }

}
