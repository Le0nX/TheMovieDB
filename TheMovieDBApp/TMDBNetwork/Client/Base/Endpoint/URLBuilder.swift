//
//  URLBuilder.swift
//  TMDBNetwork
//
//  Created by Denis Nefedov on 23.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

final class URLBuilder {
    
    // MARK: - Types
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }

    enum ParameterEnconding {
        case defaultEncoding
        case jsonEncoding
    }
    
    // MARK: - Public methods
    
    func build(for path: String,
               method: HTTPMethod,
               parameterEncoding: ParameterEnconding = .defaultEncoding,
               params: [String: Any]? = nil,
               headers: [String: String]? = nil
    ) throws -> URLRequest {
        
        let url = creteUrlComponents(for: path,
                                     method: method,
                                     parameterEncoding: parameterEncoding,
                                     params: params
        ).url!
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        guard let params = params, method != .get else { return request }

        switch parameterEncoding {
        case .defaultEncoding:
            request.httpBody = params.percentEncode()
        case .jsonEncoding:
            request.setJSONContentType()
            let jsonData = try JSONSerialization.data(withJSONObject: params)
            request.httpBody = jsonData
        }

        return request
    }
        
    // MARK: - Private Methods
    
    private func creteUrlComponents(for path: String,
                                    method: HTTPMethod,
                                    parameterEncoding: ParameterEnconding = .defaultEncoding,
                                    params: [String: Any]? = nil
    ) -> URLComponents {
        
        var components = URLComponents(string: "")!
        components.path = path
        var queryItems = [URLQueryItem(name: "api_key", value: "462eae24aa8df4234b6774c7088f312d"),
                          URLQueryItem(name: "language", value: Locale.current.languageCode)]

        switch parameterEncoding {
        case .defaultEncoding:
            if let params = params, method == .get {
                queryItems.append(contentsOf: params.map {
                    let item = URLQueryItem(name: "\($0)", value: "\($1)")
                    return item
                })
            }
        case .jsonEncoding:
            break
        }

        components.queryItems = queryItems
        return components
    }
}
