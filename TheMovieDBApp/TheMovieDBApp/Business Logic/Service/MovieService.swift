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
    
    /// Метод получения постера к фильму
    /// - Parameter poster: адрес постера
    /// - Parameter completion: обработчик
    func fetchMoviePoster(for poster: String, completion: @escaping (APIResult<Data>) -> Void)
}

/// Сервис работы с фильмами
/// Позволяет получить список фильмов
final public class MoviesService: MovieService {
    
    // MARK: - Types
    
    typealias Result = APIResult<[MovieEntity]>
    
    // MARK: - Private Properties
    
    private let client: APIClient
    private let posterClient: APIClient
    private let simpleCache = NSCache<NSString, NSData>()

    // MARK: - Initializers
    
    init(client: APIClient, posterClient: APIClient) {
        self.client = client
        self.posterClient = posterClient
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
                let movies = movieDTO.results?.map { MovieEntity(title: $0.title ?? "",
                                                                 originalTitle: $0.originalTitle ?? "",
                                                                 popularity: $0.popularity,
                                                                 voteCount: $0.voteCount,
                                                                 genreIds: $0.genreIds,
                                                                 image: $0.posterPath)
                }
                completion(.success(movies ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// Метод получения постера к фильму вместе с кэшированием
    ///
    /// - Parameter poster: адрес постера
    /// - Parameter completion: обработчик
    func fetchMoviePoster(for poster: String, completion: @escaping (APIResult<Data>) -> Void) {
      
        if let cachedVersion = simpleCache.object(forKey: NSString(string: poster)) {
            completion(.success(cachedVersion as Data))
        }
        
        let endpoint = PosterEndpoint(poster: poster)
        
        posterClient.request(endpoint) { [weak self] result in
            switch result {
            case .success(let posterData):
                
                self?.simpleCache.setObject(posterData as NSData, forKey: NSString(string: poster))
                completion(.success(posterData))
                    
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
            
        }
    }
    
}
