//
//  AuthService.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

enum LoginServiceResult {
    case success(UserSession)
    case failure(APIError)
}

protocol AuthService {
    
    /// Метод авторизации пользователя
    /// - Parameter login: логин пользователя
    /// - Parameter password: пароль пользователя
    /// - Parameter completion: обработчик авторизации или ошибки авторизации
    func signInUser(with login: String, password: String, completion: @escaping (LoginServiceResult) -> Void)
    
    /// TODO: - Signout()
}

/// Сервис авторизации пользователя.
/// Позволяет создать и сохранить пользовательскую сессию
final public class LoginService: AuthService {
    
    // MARK: - Types
    
    typealias Result = LoginServiceResult
    
    // MARK: - Constants
    
    private let client: AuthClient
            
    // MARK: - Private Properties
    
    private var accessService: AccessCredentialsService
    
    // MARK: - Initializers
    
    init(client: AuthClient, accessService: AccessCredentialsService) {
        self.client = client
        self.accessService = accessService
    }
    
    // MARK: - Public methods
    
    /// Метод авторизации пользователя
    /// - Parameter login: логин пользователя
    /// - Parameter password: пароль пользователя
    /// - Parameter completion: обработчик авторизации или ошибки авторизации
    func signInUser(with login: String, password: String, completion: @escaping (Result) -> Void) {
        client.createRequestToken { result in
            switch result {
            case .success(let requestToken):
                self.validateToken(with: requestToken.requestToken,
                                   login: login,
                                   password: password,
                                   completion: completion)
            case .failure(let error):
                print(error.description)
                completion(.failure(error))
            }
        }
    }
        
    // MARK: - Private Methods

    private func validateToken(with requestToken: String,
                               login: String,
                               password: String,
                               completion: @escaping (Result) -> Void) {
        client.validateRequestToken(with: requestToken, login: login, password: password) { result in
            switch result {
            case .success(let requestToken):
                self.createSessionId(with: requestToken, completion: completion)
            case .failure(let error):
                print(error.description)
                completion(.failure(error))
            }
        }
    }
        
    private func createSessionId(with requestToken: RequestToken,
                                 completion: @escaping (Result) -> Void) {
        client.createSessionId(with: requestToken.requestToken) { result in
            switch result {
            case .success(let sessionResult):
                guard let sessionId = sessionResult.sessionId else { return }
                    print(sessionId)
                completion(.success(sessionResult))
                let credentials = UserSessionData(token: requestToken.requestToken,
                                                  expires: requestToken.expiresAt,
                                                  session: sessionResult.sessionId ?? "")
                self.accessService.credentials = credentials
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
