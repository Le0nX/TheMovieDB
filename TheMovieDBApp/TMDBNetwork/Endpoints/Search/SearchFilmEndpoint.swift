//
//  SearchEndpoint.swift
//  TMDBNetwork
//
//  Created by Denis Nefedov on 17.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

public struct SearchFilmEndpoint: Endpoint {
    
    // MARK: - Types
    
    public typealias Content = MovieResponse
        
    // MARK: - Public Properties
    
    public var path: String {
        "/3/search/movie"
    }
        
    public var headers: [String: String]? {
        nil
    }
        
    public var params: [String: Any]? {
        ["query": searchText]
    }
        
    public var parameterEncoding: ParameterEnconding {
        .defaultEncoding
    }
        
    public var method: HTTPMethod {
        .get
    }
    
    // MARK: - Private Properties
    
    private var searchText: String
        
    // MARK: - Initializers

    public init(search: String) {
        self.searchText = search
    }
    
    // MARK: - Public methods
    
    /// Метод парсинга MovieResponse из респонза
    /// - Parameter data: данные из респоза
    /// - Parameter response: респонз
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
