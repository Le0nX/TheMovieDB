//
//  AuthProvider.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

struct RequestTokenEndpoint: Endpoint {
    
    typealias Content = RequestToken
        
    var path: String {
        "/3/authentication/token/new"
    }
        
    var headers: [String: String]? {
        nil
    }
        
    var params: [String: Any]? {
        nil
    }
        
    var parameterEncoding: ParameterEnconding {
        .defaultEncoding
    }
        
    var method: HTTPMethod {
        .get
    }
    
    func content(from data: Data, response: URLResponse?) throws -> RequestToken {
        
        guard let response = response as? HTTPURLResponse else {
            throw APIError.badRequest
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
        let content = try decoder.decode(RequestToken.self, from: data)
        return content
    }
    
}
