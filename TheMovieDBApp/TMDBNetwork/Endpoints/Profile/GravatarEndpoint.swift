//
//  GravatarEndpoint.swift
//  TMDBNetwork
//
//  Created by Denis Nefedov on 17.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

public struct GravatarEndpoint: Endpoint {
    
    public typealias Content = Data
        
    private var hash: String
    
    public var path: String {
        hash + ".jpg"
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
    
    public init(hash: String) {
        self.hash = hash
    }
    
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
