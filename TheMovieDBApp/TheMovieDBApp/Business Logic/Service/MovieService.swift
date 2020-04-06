//
//  MovieService.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 18.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import TMDBNetwork

protocol MovieService {
    
    /// Метод поиска фильмов
    ///
    /// - Parameter completion: обработчик данных профиля
    func searchFilm(name: String, completion: @escaping (APIResult<[MovieEntity]>) -> Void)
}

/// Сервис работы с фильмами
/// Позволяет получить список фильмов
final public class MoviesService: MovieService {
    
    // MARK: - Types
    
    typealias Result = APIResult<[MovieEntity]>
    
    // MARK: - Private Properties
    
    private let client: APIClient

    // MARK: - Initializers
    
    init(client: APIClient) {
        self.client = client
    }
    
    // MARK: - Public methods
    
    /// Метод поиска фильмов
    ///
    /// - Parameter name: имя поиска
    /// - Parameter completion: обработчика результата
    func searchFilm(name: String, completion: @escaping (Result) -> Void) {
        let endpoint = SearchFilmEndpoint(search: name)
        client.request(endpoint) { result in
            switch result {
            case .success(let movieDTO):
                completion(.success(MovieMapper.map(from: movieDTO)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
