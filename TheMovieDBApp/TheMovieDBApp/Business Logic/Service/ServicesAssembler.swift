//
//  ServiceAssembler.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 08.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import KeychainAccess
import TMDBNetwork

protocol ServicesAssembler {
    
    /// Сервис авторизации
    var authService: AuthService { get }
    
    /// Сервис доступа к sensetive данным пользователя
    var accessService: AccessCredentialsService { get }
    
    /// Сервис настроек профиля
    var profileService: ProfileService { get }
}

/// Фабрика сервисов
final class ServiceFabric: ServicesAssembler {
    
    /// Сервис авторизации
    lazy var authService: AuthService = {
        let config = APIClientConfig(base: "https://api.themoviedb.org")
        let service = LoginService(client: TMDBAPIClient(config: config), accessService: accessService)
        return service
    }()
    
    /// Сервис авторизации
    lazy var profileService: ProfileService = {
        let config = APIClientConfig(base: "https://api.themoviedb.org")
        let service = UserProfileService(client: TMDBAPIClient(config: config), accessService: accessService)
        return service
    }()
    
    /// Сервис хранения пользовательских credentials
    lazy var accessService: AccessCredentialsService = {
        let keychain = Keychain(service: "KeychainStorage")
        let access = AccessCredentials(keychain: keychain)
        return access
    }()
}
