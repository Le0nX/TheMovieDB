//
//  AccessCredentialsServiceTest.swift
//  TheMovieDBAppTests
//
//  Created by Denis Nefedov on 26.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import KeychainAccess
@testable import TheMovieDBApp
import XCTest

final class AccessCredentialsServiceTest: XCTestCase {
    
    func test_saveAndReceiveInfo() {
        let service = makeSUT()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        
        let data = UserSessionData(token: "token", expires: dateString, session: "testSession", accountId: 0)
        service.credentials = data
        
        XCTAssertEqual(data, service.credentials)
    }
    
    func test_validateDate() {
        let service = makeSUT()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dateString = dateFormatter.string(from: Date())
        
        let data = UserSessionData(token: "token", expires: dateString, session: "testSession", accountId: 0)
        service.credentials = data
        
        XCTAssertFalse(service.sessionIsValid())
    }
    
    func test_delete() {
        let service = makeSUT()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        
        let data = UserSessionData(token: "token", expires: dateString, session: "testSession", accountId: 0)
        service.credentials = data
        
        XCTAssertNotNil(service.credentials)
        try? service.delete()
        XCTAssertNil(service.credentials)
    }
    
    // MARK: - Private helpers
    
    /// make System Under Test
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> AccessCredentials {
        let keychain = Keychain(service: "KeychainTestStorage")
        let service = AccessCredentials(keychain: keychain)
        
        trackForMemoryLeaks(service, file: file, line: line)
        
        return service
    }
}
