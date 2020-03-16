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
    
    private var session: URLSession
    
    // MARK: - Initializers
    
    public init(session: URLSession = URLSession(configuration: .ephemeral)) {
        self.session = session
    }
        
    // MARK: - Public methods
    
    @discardableResult
    public func request<T>(_ endpoint: T,
                           completionHandler: @escaping (APIResult<T.Content>) -> Void
    ) -> Progress where T: Endpoint {
        
        guard let request = try? endpoint.makeRequest() else {
            completionHandler(.failure(APIError.requestFailed))
            return Progress()
        }
        
        let task = session.dataTask(with: request) { data, response, _ in
            DispatchQueue.main.async {
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completionHandler(.failure(APIError.badRequest))
                    return
                }
               
                if let data = data {
                    do {
                        let genericModel = try endpoint.content(from: data, response: httpResponse)
                        completionHandler(.success(genericModel))
                    } catch {
                        completionHandler(.failure(error))
                    }
                } else {
                    completionHandler(.failure(APIError.requestFailed)) // данные не пришли
                }
                
            }
        }
        
        task.resume()
        return task.progress
    }
}
