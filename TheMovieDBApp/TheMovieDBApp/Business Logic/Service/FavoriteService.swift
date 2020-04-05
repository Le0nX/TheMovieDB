//
//  FavoriteService.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 02.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import TMDBNetwork

protocol FavoritesService: MovieService {
    
    /// Метод получения фаворитов
    ///
    /// - Parameter completion: обработчик данных профиля
    func getFavorites(completion: @escaping (APIResult<[MovieEntity]>) -> Void)
}

/// Сервис данных профиля пользователя.
/// Позволяет получить аватарку и содержимое профиля
final public class FavoriteService: FavoritesService {
    // MARK: - Types
    
    typealias Result = APIResult<[MovieEntity]>
    
    // MARK: - Private Properties
    
    private let client: APIClient
    private let posterClient: APIClient
    private let accessService: AccessCredentialsService
    private let simpleCache = NSCache<NSString, NSData>()
    private var runningTasks: [UUID: Progress] = [:]

    // MARK: - Initializers
    
    init(client: APIClient, posterClient: APIClient, accessService: AccessCredentialsService) {
        self.accessService = accessService
        self.client = client
        self.posterClient = posterClient
    }
    
    // MARK: - Public methods
    
    func getFavorites(completion: @escaping (APIResult<[MovieEntity]>) -> Void) {
        guard let session = accessService.credentials?.session else {
            return
        }
        // TODO: - переделать. Сделано для быстрого получения фаворитов
        let endpoint = ProfileEndpoint(sessionId: session)
        client.request(endpoint) { [weak self] result in
            switch result {
            case .success(let profileDTO):
                let endpoint = FavoriteEndpoint(accountId: profileDTO.id, page: 1, sessionId: session)
                
                self?.client.request(endpoint) { result in
                    switch result {
                    case .success(let movieDTO):
                        completion(.success(MovieMapper.map(from: movieDTO)))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
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
