//
//  FavoriteService.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 02.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import DAO
import CoreData
import Foundation
import TMDBNetwork

protocol FavoritesService {
    
    /// Метод получения фаворитов
    ///
    /// - Parameter completion: обработчик данных профиля
    func getFavorites(for model: FavoriteServiceModel, completion: @escaping (APIResult<[MovieEntity]>) -> Void)
    
    /// Метод обработки нажатиия на добавление/удаление фаворитов
    /// - Parameter model: модель с данным для запроса
    /// - Parameter completion: результат операции
    func markFavorite(for model: FavoriteServiceMarkModel,
                      completion: @escaping (APIResult<MarkAsFavoriteResponse>) -> Void)
    
    /// Метод проверки текущего фильма на принадлежность к фаворитам
    /// - Parameters:
    ///   - sesssionId: текущая сессия
    ///   - movieId: id фильма
    ///   - complition: обработчик
    func checkIfFavorite(sessionId: String,
                         movieId: Int,
                         complition: @escaping (APIResult<AccountStateResponse>) -> Void)
}

/// Сервис фаворитов
/// Позволяет получить/модифицировать данные о любимых фильмах
final public class FavoriteService: FavoritesService {
    
    // MARK: - Types
    
    typealias Result = APIResult<[MovieEntity]>
    
    // MARK: - Private Properties
    
    private let client: APIClient
    private let dao: CoreDataDAO<MovieEntity, CoreDataMovieEntry>?

    // MARK: - Initializers
    
    init(client: APIClient) {
        self.client = client
        let translator = CoreDataMovieTranslator()
        let configuration = CoreDataConfiguration(containerName: "FavoriteMovies",
                                                  storeType: NSInMemoryStoreType)
        self.dao = try? CoreDataDAO<MovieEntity, CoreDataMovieEntry>(translator, configuration: configuration)
    }
    
    // MARK: - Public methods
    
    func getFavorites(for model: FavoriteServiceModel, completion: @escaping (APIResult<[MovieEntity]>) -> Void) {

        let endpoint = FavoriteEndpoint(accountId: model.profileId, page: model.page, sessionId: model.sessionId)
        
        client.request(endpoint) { result in
            switch result {
            case .success(let movieDTO):
                let movies = MovieMapper.map(from: movieDTO)
                try? self.dao?.persist(movies)
                print(try? self.dao?.read())
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func markFavorite(for model: FavoriteServiceMarkModel,
                      completion: @escaping (APIResult<MarkAsFavoriteResponse>) -> Void) {
        let endpoint = MarkAsFavoriteEndpoint(accountId: model.accountId,
                                              sessionId: model.sessionId,
                                              movieId: model.movieId,
                                              isFavorite: model.isFavorite)
        
        client.request(endpoint) { result in
            switch result {
            case .success(let favoriteMark):
                completion(.success(favoriteMark))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func checkIfFavorite(sessionId: String,
                         movieId: Int,
                         complition: @escaping (APIResult<AccountStateResponse>) -> Void) {
        let endpoint = AccountStateEndpoint(sessionId: sessionId, movieId: movieId)
        
        client.request(endpoint) { result in
            switch result {
            case .success(let accountState):
                complition(.success(accountState))
            case .failure(let error):
                complition(.failure(error))
            }
            
        }
    }
    
}
