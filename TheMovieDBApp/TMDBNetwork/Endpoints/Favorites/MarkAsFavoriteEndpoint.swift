//
//  MarkAsFavoriteEndpoint.swift
//  TMDBNetwork
//
//  Created by Denis Nefedov on 07.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

/// Endpoint добавления/удаления фильма в избранные
public struct MarkAsFavoriteEndpoint: Endpoint {
    
    // MARK: - Types
    
    public typealias Content = MarkAsFavoriteResponse
    
    // MARK: - Private Properties
    
    private var path: String {
        "/3/account/\(accountId)/favorite"
    }
        
    private var params: [String: Any]? {
        let queryParams: [String: Any] = ["session_id": sessionId]
        let bodyParams: [String: Any] = ["media_type": "movie",
                                         "media_id": movieId,
                                         "favorite": isFavorite]
        return ["query": queryParams, "body": bodyParams]
    }

    private let accountId: Int
    private let sessionId: String
    private let movieId: Int
    private let isFavorite: Bool
    
    // MARK: - Initializers

    public init(accountId: Int, sessionId: String, movieId: Int, isFavorite: Bool) {
        self.accountId = accountId
        self.sessionId = sessionId
        self.movieId = movieId
        self.isFavorite = isFavorite
    }
    
    // MARK: - Public methods
    
    public func makeRequest() throws -> URLRequest {
        try URLBuilder().build(for: path, method: .post, parameterEncoding: .compositeEncoding, params: params)
    }

    public func content(from data: Data, response: URLResponse?) throws -> Content {
        
        guard let response = response as? HTTPURLResponse else {
            throw APIError.invalidData
        }
        
        if response.statusCode != 201 {
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
