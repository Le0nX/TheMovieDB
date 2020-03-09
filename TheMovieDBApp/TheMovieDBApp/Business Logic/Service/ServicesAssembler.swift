//
//  ServiceAssembler.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 08.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import KeychainAccess

protocol ServicesAssembler {
    var authService: AuthService! { get }
}

class ServiceFabric: ServicesAssembler {
    
    /// Сервис авторизации
    lazy var authService: AuthService! = {
        let service = LoginService(client: AuthClient(), accessService: accessService)
        return service
    }()
    
    /// Сервис хранения пользовательских credentials
    lazy var accessService: AccessCredentialsService = {
        let keychain = Keychain(service: "KeychainStorage")
        let access = AccessCredentials(keychain: keychain)
        return access
    }()
}
