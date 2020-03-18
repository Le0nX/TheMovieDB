//
//  PosterEndpoint.swift
//  TMDBNetwork
//
//  Created by Denis Nefedov on 18.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

public struct PosterEndpoint: Endpoint {
    
    // MARK: - Types
    
    public typealias Content = Data
    
    // MARK: - Public Properties
    
    public var path: String {
        poster
    }
        
    public var headers: [String: String]? {
        nil
    }
        
    public var params: [String: Any]? {
        nil
    }
        
    public var parameterEncoding: ParameterEnconding {
        .defaultEncoding
    }
        
    public var method: HTTPMethod {
        .get
    }
    
    // MARK: - Private Properties
    
    private var poster: String
    
    // MARK: - Initializers

    public init(poster: String) {
        self.poster = poster
    }
    
    // MARK: - Public methods
    
    /// Метод парсинга Data из респонза
    /// картинки парсятся в Data для избежания зависимости от UIKit
    /// - Parameter data: данные из респоза
    /// - Parameter response: респонз
    public func content(from data: Data, response: URLResponse?) throws -> Content {
        
        guard let response = response as? HTTPURLResponse else {
            throw APIError.invalidData
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        if response.statusCode != 200 {
            throw APIError.unknown(response)
        }
        
        return data
    }
    
}
