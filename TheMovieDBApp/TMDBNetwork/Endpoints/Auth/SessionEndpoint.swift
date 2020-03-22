//
//  SessionEndpoint.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 16.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

public struct SessionEndpoint: Endpoint {
    
    // MARK: - Types

    public typealias Content = UserSession
    
    // MARK: - Public Properties

    public var path: String {
        "/3/authentication/session/new"
    }
        
    public var headers: [String: String]? {
        nil
    }
        
    public var params: [String: Any]? {
        ["request_token": token]
    }
        
    public var parameterEncoding: ParameterEnconding {
        .jsonEncoding
    }
        
    public var method: HTTPMethod {
        .post
    }
    
    // MARK: - Private Properties
    
    private let token: String
    
    // MARK: - Initializers

    public init(with validatedToken: String) {
        self.token = validatedToken
    }
    
    // MARK: - Public methods

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
