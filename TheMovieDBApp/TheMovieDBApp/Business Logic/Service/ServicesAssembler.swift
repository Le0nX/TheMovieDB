//
//  ServiceAssembler.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 08.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import CoreData
import KeychainAccess
import TMDBNetwork
import DAO

protocol ServicesAssembler {
    
    /// Сервис авторизации
    var authService: AuthService { get }
    
    /// Сервис доступа к sensetive данным пользователя
    var accessService: AccessCredentialsService { get }
    
    /// Сервис настроек профиля
    var profileService: ProfileService { get }
    
    /// Сервис получения списка фильмов
    var movieService: MovieService { get }
    
    /// Сервис работы с фаворитами
    var favoriteService: FavoritesService { get }
    
    /// Загрузчик постеров с TMDB
    func imageLoader() -> ImageLoader
}

/// Фабрика сервисов
final class ServiceFabric: ServicesAssembler {
    
    private lazy var client: APIClient = {
        let config = APIClientConfig(base: "https://api.themoviedb.org")
        return TMDBAPIClient(config: config)
    }()
    
    private lazy var favoritesDao: (CoreDataDAO<MovieEntity, CoreDataMovieEntry>?,
        RealmDAO<MovieEntity, RealmMovieEntry>) = {
            let translator = CoreDataMovieTranslator()
            let configuration = CoreDataConfiguration(containerName: "FavoriteMovies",
                                                      storeType: NSInMemoryStoreType)
            let coreDataDao = try? CoreDataDAO<MovieEntity, CoreDataMovieEntry>(translator,
                                                                                configuration: configuration)
            
            let realmTranslator = RealmMovieTranslator()
            let realmConfig = RealmConfiguration()
            let realmDao = RealmDAO<MovieEntity, RealmMovieEntry>(realmTranslator, configuration: realmConfig)
            
            return (coreDataDao, realmDao)
    }()
    
    private lazy var profileDao: RealmDAO<Profile, RealmProfileEntry> = {
            
            let realmTranslator = RealmProfileTranslator()
            let realmConfig = RealmConfiguration(databaseFileName: "profile.realm")
            let realmDao = RealmDAO<Profile, RealmProfileEntry>(realmTranslator, configuration: realmConfig)
            
            return realmDao
    }()
    
    private lazy var posterDao: RealmDAO<PosterEntity, RealmPosterEntry> = {
            
            let realmTranslator = RealmPosterTranslator()
            let realmConfig = RealmConfiguration(databaseFileName: "poster.realm")
            let realmDao = RealmDAO<PosterEntity, RealmPosterEntry>(realmTranslator, configuration: realmConfig)
            
            return realmDao
    }()
    
    private lazy var posterClient: APIClient = {
        let config = APIClientConfig(base: "https://image.tmdb.org")
        return TMDBAPIClient(config: config)
    }()
    
    /// Сервис авторизации
    lazy var authService: AuthService = {
        let service = LoginService(client: client, accessService: accessService)
        return service
    }()
    
    /// Сервис авторизации
    lazy var profileService: ProfileService = {
        let config = APIClientConfig(base: "https://secure.gravatar.com/avatar/")
        let imageClient = TMDBAPIClient(config: config)
        let service = UserProfileService(client: client,
                                         imageClient: imageClient,
                                         accessService: accessService,
                                         dao: profileDao)
        return service
    }()
    
    /// Сервис хранения пользовательских credentials
    lazy var accessService: AccessCredentialsService = {
        let keychain = Keychain(service: "KeychainStorage")
        let access = AccessCredentials(keychain: keychain)
        return access
    }()
    
    /// Сервис получения списка фильмов
    lazy var movieService: MovieService = {
        let service = MoviesService(client: client)
        return service
    }()
    
    /// Сервис работы с фаворитами
    lazy var favoriteService: FavoritesService = {
        let simpleCache = NSCache<NSString, NSData>()
        let (coredataDao, realmDao) = favoritesDao
        let service = FavoriteService(client: client, realmDao: realmDao, coredataDao: coredataDao)
        return service
    }()
    
    func imageLoader() -> ImageLoader {
        let loader = TMDBImageLoader(posterClient, dao: posterDao)
        return loader
    }
}
