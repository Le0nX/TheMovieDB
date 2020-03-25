//
//  ProfileServiceTest.swift
//  TheMovieDBAppTests
//
//  Created by Denis Nefedov on 26.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

@testable import TheMovieDBApp
@testable import TMDBNetwork
import XCTest

final class ProfileServiceTest: XCTestCase {
    
    func test_emptyRequest() {
        let (client, _) = makeSUT()
        
        XCTAssertTrue(client.urlRequests.isEmpty)
    }
    
    /// Проверка на то, что два вызова подряд будут в правильном кол-ве и порядке
    func test_twiceCall() {
        
        let (client, service) = makeSUT()
        
        service.userInfo { _ in }
        service.userInfo { _ in }
        
        let endpoint = ProfileEndpoint(sessionId: ServiceFabric().accessService.credentials!.session)
        let endpoint2 = ProfileEndpoint(sessionId: ServiceFabric().accessService.credentials!.session)
        
        XCTAssertEqual(client.urlRequests, [try? endpoint.makeRequest(), try? endpoint2.makeRequest()])
    }
    
    // MARK: - Private helpers
    
    /// make System Under Test
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (APIClientSpy, UserProfileService) {
        let client = APIClientSpy()
        let service = UserProfileService(client: client, accessService: ServiceFabric().accessService)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(service, file: file, line: line)
        
        return (client, service)
    }
}
