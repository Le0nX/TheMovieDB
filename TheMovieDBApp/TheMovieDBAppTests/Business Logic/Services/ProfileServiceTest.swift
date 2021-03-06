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
        
        let endpoint = ProfileEndpoint(sessionId: AccessServiceMock().credentials?.session ?? "")
        let endpoint2 = ProfileEndpoint(sessionId: AccessServiceMock().credentials?.session ?? "")
        
        XCTAssertEqual(client.urlRequests, [try? endpoint.makeRequest(), try? endpoint2.makeRequest()])
    }
    
    /// Проверка на ответ от APIClient'a о невалидных данных
    func test_onUserInvalidDataError() {
        let (client, service) = makeSUT()
        let endpoint = ProfileEndpoint(sessionId: AccessServiceMock().credentials?.session ?? "")
        
        expectUserInfo(service, toCompleteWith: .failure(APIError.invalidData), when: {
            let clientError = APIError.invalidData
            client.complete(for: endpoint, with: clientError)
        })
    }
    
    // MARK: - Private helpers
    
    private class AccessServiceMock: AccessCredentialsService {
        
        // MARK: - Public Properties
        
        var credentials: UserSessionData? {
            get {
                data
            }
            
            set {
                data = newValue!
            }
        }
        
        // MARK: - Private Properties
        
        private var data: UserSessionData? = UserSessionData(token: "token",
                                                             expires: "",
                                                             session: "session_id",
                                                             accountId: 0)

        // MARK: - Public methods
       
        func sessionIsValid() -> Bool {
            true
        }
        
        func delete() throws {
            data = nil
        }
    }
    
    /// make System Under Test
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (APIClientSpy, UserProfileService) {
        let client = APIClientSpy()
        let service = UserProfileService(client: client,
                                         imageClient: client, accessService: AccessServiceMock())
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(service, file: file, line: line)
        
        return (client, service)
    }
    
    private func expectUserInfo(_ sut: UserProfileService,
                                toCompleteWith expectedResult: Result<Profile, Error>,
                                when action: () -> Void,
                                file: StaticString = #file,
                                line: UInt = #line) {
            
        let exp = expectation(description: "Ждем конца загрузки")
        
        sut.userInfo { receivedResult in
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
