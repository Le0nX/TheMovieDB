//
//  GravatarEndpoint.swift
//  TMDBNetwork
//
//  Created by Denis Nefedov on 17.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

public struct GravatarEndpoint: Endpoint {
    
    // MARK: - Types
    
    public typealias Content = Data
    
    // MARK: - Private Properties
    
    private var hash: String
    
    private var path: String {
        hash + ".jpg"
    }
    
    // MARK: - Initializers

    public init(hash: String) {
        self.hash = hash
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
