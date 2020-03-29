//
//  APIClientSpy.swift
//  TheMovieDBAppTests
//
//  Created by Denis Nefedov on 25.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import TMDBNetwork

/// Перехватчик запросов. Необходим для проверки асинхронного взаимодействия
/// и вызова ожидаемого поведения в сервисах
final class APIClientSpy: APIClient {
    
    // MARK: - Public Properties
    
    var urlRequests: [URLRequest] {
        messages.map { $0.url }
    }
    
    // MARK: - Private Properties
    
    private var messages = [(url: URLRequest, completion: Any)]()
    
    // MARK: - Public methods
    
    /// Мок метод запроса. Сохраняет замыкание и запрос
    func request<T>(_ endpoint: T,
                    completionHandler: @escaping (Result<T.Content, Error>) -> Void) -> Progress where T: Endpoint {
        guard let request = try? endpoint.makeRequest() else { return Progress() }
        
        messages.append((request, completionHandler))
        
        return Progress()
    }
    
    /// Мок метод вызова ожидаемой ошибки
    /// - Parameter for: endpoint необходим для дедуцирования типа
    /// - Parameter error: ожидаемая ошибка
    /// - Parameter index: индекс из перехваченных вызовов
    func complete<T>(for: T, with error: Error, at index: Int = 0) where T: Endpoint {
        let complition = messages[index].completion as? (Result<T.Content, Error>) -> Void
        complition?(.failure(error))
    }
    
    /// Мок метод передачи ожидаемых данных
    /// - Parameter for: endpoint необходим для дедуцирования типа
    /// - Parameter error: ожидаемая ошибка
    /// - Parameter index: индекс из перехваченных вызовов
    func complete<T>(for: T, with data: T.Content, at index: Int = 0) where T: Endpoint {
        let complition = messages[index].completion as? (Result<T.Content, Error>) -> Void
        complition?(.success(data))
    }

}
