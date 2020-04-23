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
    
    /// Метод сохранения пинкода в keychain
    func save(pinCode: String)
    
    /// Метод проверки пинкода на основе сессии
    func check(pinCode: String) -> Bool
    
    /// выход
    func logout()
    
    /// Метод получения данных профиля для верхней части ViewControllera
    func getProfile(completion: @escaping (APIResult<Profile>) -> Void)
    
    /// Метод авторизации по faceId/touchId
    func bioAuth(completion: @escaping (Bool) -> Void)
}

/// Лоадер-фасад экрана пиинкода,
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
        accessService.crypt(pinCode)
    }
    
    func check(pinCode: String) -> Bool {
        accessService.decrypt(pinCode)
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
