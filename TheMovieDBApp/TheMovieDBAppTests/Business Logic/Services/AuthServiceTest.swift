//
//  AuthServiceTest.swift
//  TheMovieDBAppTests
//
//  Created by Denis Nefedov on 26.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

@testable import TMDBNetwork
import XCTest

class AuthServiceTest: XCTestCase {
    
    func test_emptyRequest() {
        let (client, _) = makeSUT()
        
        XCTAssertTrue(client.urlRequests.isEmpty)
    }
    
    /// Проверка на то, что два вызова подряд будут в правильном кол-ве и порядке
    func test_twiceCall() {
        
        let (client, service) = makeSUT()
        
        service.signInUser(with: "login", password: "passwd") { _ in }
        service.signInUser(with: "login2", password: "passwd2") { _ in }
        
        let endpoint = RequestTokenEndpoint()
        let endpoint2 = RequestTokenEndpoint()
        
        XCTAssertEqual(client.urlRequests, [try? endpoint.makeRequest(), try? endpoint2.makeRequest()])
    }
    
    /// Проверка на ответ от APIClient'a о невозможности залогиниться
    func test_onFilmInvalidDataError() {
        let (client, service) = makeSUT()
        let endpoint = RequestTokenEndpoint()
        
        expectAuth(service, toCompleteWith: .failure(APIError.authFailed), when: {
            let clientError = APIError.authFailed
            client.complete(for: endpoint, with: clientError)
        })
    }

    // MARK: - Private helpers
       
    /// make System Under Test
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (APIClientSpy, LoginService) {
        let client = APIClientSpy()
        let service = LoginService(client: client, accessService: ServiceFabric().accessService)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(service, file: file, line: line)

        return (client, service)
    }
    
    private func expectAuth(_ sut: LoginService,
                            toCompleteWith expectedResult: Result<UserSession, Error>,
                            when action: () -> Void,
                            file: StaticString = #file,
                            line: UInt = #line) {
               
       let exp = expectation(description: "Ждем конца загрузки")
       
       sut.signInUser(with: "login", password: "passwd") { receivedResult in
           switch (receivedResult, expectedResult) {
           case let (.success(receivedItems), .success(expectedItems)):
               XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
               
           case let (.failure(receivedError as APIError), .failure(expectedError as APIError)):
               XCTAssertEqual(receivedError.localizedDescription,
                              expectedError.localizedDescription,
                              file: file,
                              line: line)
               
           default:
               XCTFail("Ожидали результат \(expectedResult),получили \(receivedResult) вместо", file: file, line: line)
           }
           
           exp.fulfill()
       }
       
       action()
       
       wait(for: [exp], timeout: 1.0)
   }

}
