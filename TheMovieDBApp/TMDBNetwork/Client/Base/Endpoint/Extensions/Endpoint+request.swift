//
//  Endpoint+request.swift
//  TMDBNetwork
//
//  Created by Denis Nefedov on 17.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

extension Endpoint {
    
    // MARK: - Public Properties
    
    var base: String {
        "https://api.themoviedb.org"
    }

    var apiKey: String {
        "462eae24aa8df4234b6774c7088f312d"
    }

    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey),
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
    
    public func makeRequest() throws -> URLRequest {
        let url = urlComponents.url!
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
            let jsonData = try? JSONSerialization.data(withJSONObject: params)
            request.httpBody = jsonData
        }

        return request
    }
}
