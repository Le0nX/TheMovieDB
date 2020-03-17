//
//  ProfileEnpoint.swift
//  TMDBNetwork
//
//  Created by Denis Nefedov on 17.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

public struct ProfileEndpoint: Endpoint {
    
    public typealias Content = Profile
        
    private var sessionId: String
    
    public var path: String {
        "/3/account"
    }
        
    public var headers: [String: String]? {
        nil
    }
        
    public var params: [String: Any]? {
        ["session_id": sessionId]
    }
        
    public var parameterEncoding: ParameterEnconding {
        .defaultEncoding
    }
        
    public var method: HTTPMethod {
        .get
    }
    
    public init(sessionId: String) {
        self.sessionId = sessionId
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
