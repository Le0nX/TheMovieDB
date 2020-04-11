//
//  ValidateTokenEndpoint.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 16.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

/// Endpoint валидации токена
public struct ValidateTokenEndpoint: Endpoint {
    
    // MARK: - Types
    
    public typealias Content = ValidateToken
    
    // MARK: - Private Properties
    
    private let path = "/3/authentication/token/validate_with_login"
    
    private var params: [String: Any]? {
        ["username": username, "password": password, "request_token": token]
    }

    private var username: String
    private var password: String
    private var token: String
    
    // MARK: - Initializers

    public init(with login: String, password: String, requestToken: String) {
        self.username = login
        self.password = password
        self.token = requestToken
    }
    
    // MARK: - Public methods
    
    public func makeRequest() throws -> URLRequest {
        try URLBuilder().build(for: path, method: .post, parameterEncoding: .jsonEncoding, params: params)
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
