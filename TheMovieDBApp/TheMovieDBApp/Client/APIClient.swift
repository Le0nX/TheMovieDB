//
//  HTTPClient.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

/// Сетевой слой, написанный на основе
/// https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908
protocol APIClient {
    
    // MARK: - Public Properties
    
    var session: URLSession { get }
    
    // MARK: - Public methods
    
    /// Дженерик метод запроса по сети
    /// - Parameter request: тело запроса
    /// - Parameter decode: кастомный декодер респонза в дженерик тип
    /// - Parameter completion: обработчик декодированного ответа на основе дженерик результата
    func fetch<T: Decodable>(with request: URLRequest,
                             decode: @escaping (Decodable) -> T?,
                             completion: @escaping (Result<T, APIError>) -> Void)
    
}

/// Дефолтная имплементация протокола APIClient
extension APIClient {
    
    // MARK: - Types
    
    typealias JSONTaskCompletionHandler = (Decodable?, APIError?) -> Void
    
    // MARK: - Public methods
    
    func fetch<T: Decodable>(with request: URLRequest,
                             decode: @escaping (Decodable) -> T?,
                             completion: @escaping (Result<T, APIError>) -> Void) {
        let task = decodingTask(with: request, decodingType: T.self) { json, error in
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.requestFailed))
                    }
                    return
                }
                if let value = decode(json) {
                    completion(.success(value))
                } else {
                    completion(.failure(.requestFailed))
                }
            }
        }
        task.resume()
    }
        
    // MARK: - Private Methods

    private func decodingTask<T: Decodable>(with request: URLRequest,
                                            decodingType: T.Type,
                                            completionHandler completion: JSONTaskCompletionHandler?)
                                            -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion?(nil, .requestFailed)
                return
            }
            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let genericModel = try decoder.decode(decodingType, from: data)
                        completion?(genericModel, nil)
                    } catch {
                        print(error.localizedDescription)
                        completion?(nil, .requestFailed)
                    }
                } else {
                    completion?(nil, .invalidData)
                }
            } else {
                completion?(nil, APIError(response: httpResponse))
            }
        }
        return task
    }
}
