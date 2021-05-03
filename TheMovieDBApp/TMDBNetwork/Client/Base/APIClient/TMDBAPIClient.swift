//
//  TMDBAPIClient.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 15.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

public final class TMDBAPIClient: APIClient {
    
    // MARK: - Private Properties
    
    private let config: APIClientConfig
    private let reachability = NetworkReachability()
    
    // MARK: - Initializers
    
    public init(config: APIClientConfig) {
        self.config = config
    }
        
    // MARK: - Public methods
    
    @discardableResult
    public func request<T>(_ endpoint: T,
                           completionHandler: @escaping (APIResult<T.Content>) -> Void
    ) -> Progress where T: Endpoint {
        if !reachability.isNetworkAvailable() {
            completionHandler(.failure(APIError.noConnection))
            return Progress()
        }
        
        var request: URLRequest
        do {
            request = try endpoint.makeRequest()
        } catch {
            completionHandler(.failure(error))
            return Progress()
        }
        
        request.url = URL(string: request.url?.absoluteString ?? "", relativeTo: config.baseUrl)
        
        let task = config.session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                
                if let error = error {
                    completionHandler(.failure(error))
                    return
                }
               
                do {
                    let genericModel = try endpoint.content(from: data ?? Data(), response: response)
                    completionHandler(.success(genericModel))
                } catch {
                    completionHandler(.failure(error))
                }
            }
        }
        
        task.resume()
        return task.progress
    }
}
