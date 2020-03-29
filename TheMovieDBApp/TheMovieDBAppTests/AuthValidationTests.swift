//
//  TheMovieDBAppTests.swift
//  TheMovieDBAppTests
//
//  Created by Denis Nefedov on 06.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

@testable import TheMovieDBApp
import XCTest

final class AuthValidationTests: XCTestCase {

    func test_EmptyCredentials() {
        let login = ""
        let password = ""
        XCTAssertFalse(isValid(login, with: password))
    }
    
    func test_wrongLengthLoginCredentials() {
        let login = ""
        let password = "1234"
        XCTAssertFalse(isValid(login, with: password))
    }
    
    func test_wrongLengthPasswordCredentials() {
        let login = "x"
        let password = "123"
        XCTAssertFalse(isValid(login, with: password))
    }
    
    func test_validCredentials() {
        let login = "x"
        let password = "1234"
        XCTAssertTrue(isValid(login, with: password))
    }

}
