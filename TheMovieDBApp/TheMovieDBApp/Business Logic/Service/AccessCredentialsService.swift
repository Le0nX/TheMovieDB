//
//  AccessCredentialsService.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import KeychainAccess

protocol AccessCredentialsService {
    var credentials: UserSessionData? { get set }
    
    /// Метод проверки валидности текущей сессии
    func sessionIsValid() -> Bool
    
    /// Метод удаления всех данных пользователя
    func delete() throws
}

final class AccessCredentials: AccessCredentialsService {
    let keychain: Keychain
    
    init(keychain: Keychain) {
        self.keychain = keychain
    }
    
    var credentials: UserSessionData? {
        get {
            obtainData()
        }
        set {
            saveData(data: newValue!)
        }
    }
    
    private func obtainData() -> UserSessionData? {
        guard let token = keychain["token"],
            let expires = keychain["expires"],
            let sessionId = keychain["sessionId"] else { return nil }
        
        return UserSessionData(token: token,
                               expiers: expires,
                               session: sessionId)
    }
    
    private func saveData(data: UserSessionData) {
        keychain["token"] = data.token
        keychain["expires"] = data.expiers
        keychain["sessionId"] = data.session
    }
    
    /// Метод проверки валидности текущей сессии
    func sessionIsValid() -> Bool {
        guard let expirationDate = keychain["expires"] else { return false }
        guard toDate(date: expirationDate) > Date() else { return false }

        return true
    }
    
    /// Метод удаления всех данных пользователя
    func delete() throws {
        keychain["token"] = nil
        keychain["expires"] = nil
        keychain["sessionId"] = nil
    }
}
