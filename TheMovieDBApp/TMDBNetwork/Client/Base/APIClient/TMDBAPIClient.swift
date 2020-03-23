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
    
    // MARK: - Initializers
    
    public init(config: APIClientConfig) {
        self.config = config
    }
        
    // MARK: - Public methods
    
    @discardableResult
    public func request<T>(_ endpoint: T,
                           completionHandler: @escaping (APIResult<T.Content>) -> Void
    ) -> Progress where T: Endpoint {
        
        var request: URLRequest
        do {
            request = try endpoint.makeRequest()
        } catch {
            completionHandler(.failure(error))
            return Progress()
        }
        
        request.url = URL(string: request.url?.absoluteString ?? "", relativeTo: config.baseUrl)
        
        let task = config.session.dataTask(with: request) { data, response, _ in
            DispatchQueue.main.async {
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completionHandler(.failure(APIError.badRequest))
                    return
                }
               
                do {
                    let genericModel = try endpoint.content(from: data ?? Data(), response: httpResponse)
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
