//
//  PinCodeLoader.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 20.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

protocol PinCodeLoader {
    func save(pinCode: String)
    
    func check(pinCode: String) -> Bool
    
    func logout()
}

/// Лоадер-фасад экрана профиля,
/// который скрывает за собой работу других сервисов
final class PinCodeLoaderImpl: PinCodeLoader {
    
    // MARK: - Private Properties
    
    private var accessService: AccessCredentialsService
    
    // MARK: - Initializers
    
    init(_ accessService: AccessCredentialsService) {
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
    
}
