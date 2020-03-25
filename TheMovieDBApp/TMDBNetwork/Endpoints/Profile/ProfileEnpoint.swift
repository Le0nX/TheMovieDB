//
//  ProfileEnpoint.swift
//  TMDBNetwork
//
//  Created by Denis Nefedov on 17.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

public struct ProfileEndpoint: Endpoint {
    
    // MARK: - Types

    public typealias Content = ProfileDTO
    
    // MARK: - Private Properties
    
    private let path = "/3/account"
        
    private var params: [String: Any]? {
        ["session_id": sessionId]
    }
    
    private var sessionId: String
    
    // MARK: - Initializers
    
    public init(sessionId: String) {
        self.sessionId = sessionId
    }
    
    // MARK: - Public methods
    
    public func makeRequest() throws -> URLRequest {
        try URLBuilder().build(for: path, method: .get, params: params)
    }
    
    /// Метод парсинга профиля из респонза
    /// 
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
