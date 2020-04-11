//
//  SessionEndpoint.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 16.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

/// Endpoint сессии
public struct SessionEndpoint: Endpoint {
    
    // MARK: - Types

    public typealias Content = UserSession

    // MARK: - Private Properties
    
    private let path = "/3/authentication/session/new"
    
    private let token: String
        
    private var params: [String: Any]? {
        ["request_token": token]
    }
    
    // MARK: - Initializers

    public init(with validatedToken: String) {
        self.token = validatedToken
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
            default:
                throw APIError.unknown(response)
            }
        }
        
        let content = try decoder.decode(Content.self, from: data)
        return content
    }
    
}
