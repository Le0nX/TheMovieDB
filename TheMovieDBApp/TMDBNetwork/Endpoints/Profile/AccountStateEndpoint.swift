//
//  AccountStateEndpoint.swift
//  TMDBNetwork
//
//  Created by Denis Nefedov on 08.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

/// Endpoint стейта фильма. Необходим для определения принадлежности к избьранному
public struct AccountStateEndpoint: Endpoint {
    
    // MARK: - Types
    
    public typealias Content = AccountStateResponse
    
    // MARK: - Private Properties
    
    private var path: String {
        "/3/movie/\(movieId)/account_states"
    }
        
    private var params: [String: Any]? {
        ["session_id": sessionId]
    }

    private let sessionId: String
    private let movieId: Int
    
    // MARK: - Initializers

    public init(sessionId: String, movieId: Int) {
        self.sessionId = sessionId
        self.movieId = movieId
    }
    
    // MARK: - Public methods
    
    public func makeRequest() throws -> URLRequest {
        try URLBuilder().build(for: path, method: .get, params: params)
    }

    public func content(from data: Data, response: URLResponse?) throws -> Content {
        
        guard let response = response as? HTTPURLResponse else {
            throw APIError.invalidData
        }
        
        if response.statusCode != 200 {
            print(response.statusCode)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let content = try decoder.decode(ErrorResponse.self, from: data)
            switch content.statusCode {
            case 7:
                throw APIError.invalidApiKey
            default:
                throw APIError.unknown(response)
            }
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let content = try decoder.decode(Content.self, from: data)
        return content
    }
    
}
