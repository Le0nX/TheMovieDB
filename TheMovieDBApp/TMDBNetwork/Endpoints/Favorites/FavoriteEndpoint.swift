//
//  FavoriteEndpoint.swift
//  TMDBNetwork
//
//  Created by Denis Nefedov on 17.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

public struct FavoriteEndpoint: Endpoint {
    
    // MARK: - Types
    
    public typealias Content = MovieResponse
    
    // MARK: - Private Properties
    
    private var path: String {
        "/3/account/\(accountId)/favorite/movies"
    }
        
    private var params: [String: Any]? {
        ["session_id": sessionId, "page": page]
    }

    private var accountId: Int
    private var sessionId: String
    private var page: Int
    
    // MARK: - Initializers

    public init(accountId: Int, page: Int, sessionId: String) {
        self.accountId = accountId
        self.page = page
        self.sessionId = sessionId
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
