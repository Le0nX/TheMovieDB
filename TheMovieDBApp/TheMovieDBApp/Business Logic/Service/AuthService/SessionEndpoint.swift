//
//  SessionEndpoint.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 16.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

struct SessionEndpoint: Endpoint {
    
    typealias Content = UserSession
 
    private var token: String
    
    var path: String {
        "/3/authentication/session/new"
    }
        
    var headers: [String: String]? {
        nil
    }
        
    var params: [String: Any]? {
        ["request_token": token]
    }
        
    var parameterEncoding: ParameterEnconding {
        .jsonEncoding
    }
        
    var method: HTTPMethod {
        .post
    }
    
    init(with validatedToken: String) {
        self.token = validatedToken
    }
    
    func content(from data: Data, response: URLResponse?) throws -> Content {
        
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
