//
//  ValidateTokenEndpoint.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 16.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

public struct ValidateTokenEndpoint: Endpoint {
    
    public typealias Content = ValidateToken
        
    private var username: String
    private var password: String
    private var token: String
    
    public var path: String {
        "/3/authentication/token/validate_with_login"
    }
        
    public var headers: [String: String]? {
        nil
    }
        
    public var params: [String: Any]? {
        ["username": username, "password": password, "request_token": token]
    }
        
    public var parameterEncoding: ParameterEnconding {
        .jsonEncoding
    }
        
    public var method: HTTPMethod {
        .post
    }
    
    public init(with login: String, password: String, requestToken: String) {
        self.username = login
        self.password = password
        self.token = requestToken
    }
    
    public func content(from data: Data, response: URLResponse?) throws -> Content {
        
        guard let response = response as? HTTPURLResponse else {
            throw APIError.invalidData
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        if response.statusCode != 200 {
            let content = try decoder.decode(ErrorResponse.self, from: data)
            switch content.statusCode {
            case 7:
                throw APIError.invalidApiKey
            case 30:
                throw APIError.authFailed
            default:
                throw APIError.unknown(response)
            }
        }
        
        let content = try decoder.decode(Content.self, from: data)
        return content
    }
    
}
