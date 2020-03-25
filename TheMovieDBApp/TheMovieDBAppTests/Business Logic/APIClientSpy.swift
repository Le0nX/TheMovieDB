//
//  APIClientSpy.swift
//  TheMovieDBAppTests
//
//  Created by Denis Nefedov on 25.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import TMDBNetwork

final class APIClientSpy: APIClient {
        
    private var messages = [(url: URLRequest, completion: Any)]()
    
    var urlRequests: [URLRequest] {
        messages.map { $0.url }
    }
    
    func request<T>(_ endpoint: T,
                    completionHandler: @escaping (Result<T.Content, Error>) -> Void) -> Progress where T: Endpoint {
        guard let request = try? endpoint.makeRequest() else { return Progress() }
        
        messages.append((request, completionHandler))
        
        return Progress()
    }
    
    func complete<T>(for: T, with error: Error, at index: Int = 0) where T: Endpoint {
        let complition = messages[index].completion as? (Result<T.Content, Error>) -> Void
        complition?(.failure(error))
    }
    
    func complete<T>(for: T, with data: T.Content, at index: Int = 0) where T: Endpoint {
        let complition = messages[index].completion as? (Result<T.Content, Error>) -> Void
        complition?(.success(data))
    }

}
