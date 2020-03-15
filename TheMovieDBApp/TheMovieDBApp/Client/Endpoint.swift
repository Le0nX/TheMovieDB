//
//  Endpoint.swift
//  TheMovieDBApp
//
//  Сетевой слой, написанный на основе
//  https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

///Enpoint предназначен для упрощения создания тела запроса.
protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var params: [String: Any]? { get }
    var parameterEncoding: ParameterEnconding { get }
    var method: HTTPMethod { get }
}

/// Дефолтная реализация протокола для TMDBApp
extension Endpoint {
    
    // MARK: - Public Properties
    
    var apiKey: String {
        // TODO: - переделать на keychain сервис и закрыть интерфейсом
        return "462eae24aa8df4234b6774c7088f312d"
    }
    
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)] // можно добавить язык на основе локализации
        
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
    
    var request: URLRequest {
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

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum ParameterEnconding {
    case defaultEncoding
    case jsonEncoding
}
