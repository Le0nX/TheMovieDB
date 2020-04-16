//
//  FavoriteService.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 02.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import TMDBNetwork
import CoreData
import DAO

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
    private let realmDao: RealmDAO<MovieEntity, RealmMovieEntry>?
    private let networkChecker = NetworkReachability()

    // MARK: - Initializers
    
    init(client: APIClient,
         realmDao: RealmDAO<MovieEntity, RealmMovieEntry>?,
         coredataDao: CoreDataDAO<MovieEntity, CoreDataMovieEntry>?) {
        
        self.client = client
        self.dao = coredataDao
        self.realmDao = realmDao
    }
    
    // MARK: - Public methods
    
    func getFavorites(for model: FavoriteServiceModel, completion: @escaping (APIResult<[MovieEntity]>) -> Void) {
        switch AppSettings.checkDataBaseSettings() {
        case .coreData:
            if let movies = self.dao?.read() {
                completion(.success(movies))
            }
        case .realm:
            if let movies = self.realmDao?.read() {
                completion(.success(movies))
            }
        }
        
        if !networkChecker.isNetworkAvailable() {
            return
        }
        
        let endpoint = FavoriteEndpoint(accountId: model.profileId, page: model.page, sessionId: model.sessionId)
        
        client.request(endpoint) { [weak self] result in
            switch result {
            case .success(let movieDTO):
                let movies = MovieMapper.map(from: movieDTO)
                try? self?.realmDao?.persist(movies)
                try? self?.dao?.persist(movies)
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
