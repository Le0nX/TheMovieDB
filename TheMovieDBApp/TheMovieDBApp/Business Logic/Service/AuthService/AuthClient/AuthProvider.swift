//
//  AuthProvider.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

enum AuthProvider {
    case createRequestToken
    case validateRequestToken(username: String, password: String, requestToken: String)
    case createSessionId(requestToken: String)
}

extension AuthProvider: Endpoint {
    var base: String {
        return "https://api.themoviedb.org"
    }
    
    var path: String {
        switch self {
        case .createRequestToken:
            return "/3/authentication/token/new"
        case .validateRequestToken:
            return "/3/authentication/token/validate_with_login"
        case .createSessionId:
            return "/3/authentication/session/new"
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .createRequestToken://(let readAccessToken):
            return nil//["Authorization": "Bearer \(readAccessToken)"]
        case .validateRequestToken:
            return nil//["Authorization": "Bearer \(readAccessToken)"]
        case .createSessionId:
            return nil
        }
    }
    
    var params: [String: Any]? {
        switch self {
        case .createRequestToken:
            return nil
        case .validateRequestToken(let username, let password, let requestToken):
            return ["username": username, "password": password, "request_token": requestToken]
        case .createSessionId(let requestToken):
            return ["request_token": requestToken]
        }
    }
    
    var parameterEncoding: ParameterEnconding {
        switch self {
        case .createRequestToken:
            return .defaultEncoding
        case .validateRequestToken, .createSessionId:
            return .jsonEncoding
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createRequestToken:
            return .get
        case .validateRequestToken, .createSessionId:
            return .post
        }
    }
}
