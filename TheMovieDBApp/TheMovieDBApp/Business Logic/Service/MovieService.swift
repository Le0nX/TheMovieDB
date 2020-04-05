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
    @discardableResult
    func fetchMoviePoster(for poster: String, completion: @escaping (APIResult<Data>) -> Void) -> UUID?
    
    /// Метод удаления таска из пула запущенных тасков, после того как постер был загружен
    /// - Parameter poster: часть url постера без baseUrl
    func cancelTask(for poster: UUID)
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
    private var runningTasks: [UUID: Progress] = [:]

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
                completion(.success(MovieMapper.map(from: movieDTO)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// Метод получения постера к фильму вместе с кэшированием
    ///
    /// - Parameter poster: адрес постера
    /// - Parameter completion: обработчик
    func fetchMoviePoster(for poster: String, completion: @escaping (APIResult<Data>) -> Void) -> UUID? {
      
        /// проверяем наличие кэша. Если есть, то завершаемся с ним
        if let cachedVersion = simpleCache.object(forKey: NSString(string: poster)) {
            completion(.success(cachedVersion as Data))
            return nil
        }
        
        let endpoint = PosterEndpoint(poster: poster)
        let posterTaskUUID = UUID()
        
        runningTasks[posterTaskUUID] = posterClient.request(endpoint) { [weak self] result in
            defer { self?.runningTasks.removeValue(forKey: posterTaskUUID) } // таска завершилась
            
            switch result {
            case .success(let posterData):
                
                self?.simpleCache.setObject(posterData as NSData, forKey: NSString(string: poster))
                completion(.success(posterData))
                    
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
        
        return posterTaskUUID
    }
    
    func cancelTask(for poster: UUID) {
        if let task = runningTasks[poster] {
            task.cancel()
            runningTasks.removeValue(forKey: poster)
        }
    }
    
}
