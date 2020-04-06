//
//  FavoriteService.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 02.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import TMDBNetwork

protocol FavoritesService {
    
    /// Метод получения фаворитов
    ///
    /// - Parameter completion: обработчик данных профиля
    func getFavorites(completion: @escaping (APIResult<[MovieEntity]>) -> Void)
}

/// Сервис фаворитов
/// Позволяет получить данные о любимых фильмах
final public class FavoriteService: FavoritesService {
    // MARK: - Types
    
    typealias Result = APIResult<[MovieEntity]>
    
    // MARK: - Private Properties
    
    private let client: APIClient
    private let accessService: AccessCredentialsService

    // MARK: - Initializers
    
    init(client: APIClient,
         accessService: AccessCredentialsService) {
        
        self.accessService = accessService
        self.client = client
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
    
}
