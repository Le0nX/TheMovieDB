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
    
    func crypt(_ pinCode: String)
    
    func decrypt(_ pinCode: String) -> Bool
    
    /// Доступ к структуре sensetive пользовательских данных
    var credentials: UserSessionData? { get set }
    
    /// Доступ к пинкоду пользователя
    var pinCode: String? { get set }
        
    /// Метод проверки валидности текущей сессии
    func sessionIsValid() -> Bool
    
    /// Метод удаления всех данных пользователя
    func delete() throws
}

/// Сервис доступа к пользовательским данным
final class AccessCredentials: AccessCredentialsService {
    
    // MARK: - Constants
    
     let keychain: Keychain
    
    // MARK: - Public Properties
        
    var credentials: UserSessionData? {
        
        get {
            obtainData()
        }
        
        set {
            saveData(data: newValue!)
        }
    }
    
    var pinCode: String? {
        get {
            keychain["pincode"]
        }
        
        set {
            keychain["pincode"] = newValue
        }
    }
        
    // MARK: - Initializers
    
    init(keychain: Keychain) {
        self.keychain = keychain
    }
        
    // MARK: - Public methods
    
    public func crypt(_ pinCode: String) {
        do {
            let sourceData = keychain["sessionId"]?.data(using: .utf8)!
            let salt = AESCrypter.randomSalt()
            let iv = AESCrypter.randomIv()
            let key = try AESCrypter.createKey(password: pinCode.data(using: .utf8)!, salt: salt)
            let aes = try AESCrypter(key: key, iv: iv)
            let encryptedData = try aes.encrypt(sourceData ?? Data())
            keychain["encryptedsessionId"] = encryptedData.base64EncodedString()
            keychain["salt"] = salt.base64EncodedString()
            keychain["iv"] = iv.base64EncodedString()
        } catch {
            print(error)
        }
        
    }

    public func decrypt(_ pinCode: String) -> Bool {
        do {
            guard let encryptedData = keychain["encryptedsessionId"] else { return false }
            guard let salt = keychain["salt"] else { return false }
            guard let iv = keychain["iv"] else { return false }
            let key = try AESCrypter.createKey(password: pinCode.data(using: .utf8)!,
                                               salt: Data(base64Encoded: salt) ?? Data())
            let aes = try AESCrypter(key: key, iv: Data(base64Encoded: iv) ?? Data())
            let decryptedData = try aes.decrypt(Data(base64Encoded: encryptedData) ?? Data())
            guard let sessionId = String(data: decryptedData, encoding: .utf8) else { return false }
            return keychain["sessionId"] == sessionId
        } catch {
            print(error)
            return false
        }
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
        keychain["accountId"] = nil
        keychain["pincode"] = nil
        keychain["encryptedsessionId"] = nil
        keychain["salt"] = nil
        keychain["iv"] = nil
    }
        
    // MARK: - Private Methods

    private func obtainData() -> UserSessionData? {
        guard let token = keychain["token"],
            let expires = keychain["expires"],
            let sessionId = keychain["sessionId"],
            let accountId = keychain["accountId"] else { return nil }
        
        return UserSessionData(token: token,
                               expires: expires,
                               session: sessionId,
                               accountId: Int(accountId)!)
    }
    
    private func saveData(data: UserSessionData) {
        keychain["token"] = data.token
        keychain["expires"] = data.expires
        keychain["sessionId"] = data.session
        keychain["accountId"] = String(data.accountId)
    }
}
