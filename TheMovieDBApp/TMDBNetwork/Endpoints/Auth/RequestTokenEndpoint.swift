//
//  AuthProvider.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

public struct RequestTokenEndpoint: Endpoint {
    
    // MARK: - Types
    
    public typealias Content = RequestToken
    
    // MARK: - Private Properties
        
    private let path = "/3/authentication/token/new"
    
    // MARK: - Initializers

    public init() {
        
    }
    
    // MARK: - Public methods
    
    public func makeRequest() throws -> URLRequest {
        try URLBuilder().build(for: path, method: .get)
    }

    public func content(from data: Data, response: URLResponse?) throws -> RequestToken {
        
        guard let response = response as? HTTPURLResponse else {
            throw APIError.badRequest
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
