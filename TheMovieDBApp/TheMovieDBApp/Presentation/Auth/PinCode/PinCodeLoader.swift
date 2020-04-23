//
//  PinCodeLoader.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 20.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import TMDBNetwork

protocol PinCodeLoader {
    func save(pinCode: String)
    
    func check(pinCode: String) -> Bool
    
    func logout()
    
    func getProfile(completion: @escaping (APIResult<Profile>) -> Void)
    
    func bioAuth(completion: @escaping (Bool) -> Void)
}

/// Лоадер-фасад экрана профиля,
/// который скрывает за собой работу других сервисов
final class PinCodeLoaderImpl: PinCodeLoader {
    
    // MARK: - Private Properties
    
    private var accessService: AccessCredentialsService
    private var profileService: ProfileService
    private var biometricService = BioMetricAuthenticatorServiceImp()
    
    // MARK: - Initializers
    
    init(_ accessService: AccessCredentialsService,
         profileService: ProfileService ) {
        self.profileService = profileService
        self.accessService = accessService
    }
    
    // MARK: - Public Methods
    
    func save(pinCode: String) {
        accessService.pinCode = pinCode
    }
    
    func check(pinCode: String) -> Bool {
        accessService.pinCode == pinCode
    }
    
    func logout() {
        try? accessService.delete()
    }
    
    func getProfile(completion: @escaping (APIResult<Profile>) -> Void) {
        profileService.userInfo(completion: completion)
    }
    
    func bioAuth(completion: @escaping (Bool) -> Void) {
        biometricService.authenticate(completion: completion)
    }
    
}
