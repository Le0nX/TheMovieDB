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
    
    // MARK: - Private Properties
    
    private var path: String {
        "/t/p/w185//" + poster
    }
    
    private var poster: String
    
    // MARK: - Initializers

    public init(poster: String) {
        self.poster = poster
    }
    
    // MARK: - Public methods
    
    public func makeRequest() throws -> URLRequest {
        try URLBuilder().build(for: path, method: .get)
    }
    
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
