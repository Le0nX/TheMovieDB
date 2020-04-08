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
    func getFavorites(for model: FavoriteServiceModel, completion: @escaping (APIResult<[MovieEntity]>) -> Void)
}

/// Сервис фаворитов
/// Позволяет получить данные о любимых фильмах
final public class FavoriteService: FavoritesService {
    
    // MARK: - Types
    
    typealias Result = APIResult<[MovieEntity]>
    
    // MARK: - Private Properties
    
    private let client: APIClient

    // MARK: - Initializers
    
    init(client: APIClient) {
        self.client = client
    }
    
    // MARK: - Public methods
    
    func getFavorites(for model: FavoriteServiceModel, completion: @escaping (APIResult<[MovieEntity]>) -> Void) {

        let endpoint = FavoriteEndpoint(accountId: model.profileId, page: model.page, sessionId: model.sessionId)
        
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
