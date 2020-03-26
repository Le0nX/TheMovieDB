//
//  AuthService.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import TMDBNetwork

protocol AuthService {
    
    /// Метод авторизации пользователя
    /// - Parameter login: логин пользователя
    /// - Parameter password: пароль пользователя
    /// - Parameter completion: обработчик авторизации или ошибки авторизации
    func signInUser(with login: String, password: String, completion: @escaping (APIResult<UserSession>) -> Void)
    
    /// TODO: - Signout()
}

/// Сервис авторизации пользователя.
/// Позволяет создать и сохранить пользовательскую сессию
final public class LoginService: AuthService {
    
    // MARK: - Types
    
    typealias Result = APIResult<UserSession>
    
    // MARK: - Constants
    
    private let client: APIClient
            
    // MARK: - Private Properties
    
    private var accessService: AccessCredentialsService
    
    // MARK: - Initializers
    
    init(client: APIClient, accessService: AccessCredentialsService) {
        self.client = client
        self.accessService = accessService
    }
    
    // MARK: - Public methods
    
    /// Метод авторизации пользователя
    /// - Parameter login: логин пользователя
    /// - Parameter password: пароль пользователя
    /// - Parameter completion: обработчик авторизации или ошибки авторизации
    func signInUser(with login: String, password: String, completion: @escaping (Result) -> Void) {
        let endpoint = RequestTokenEndpoint()
        client.request(endpoint) { [weak self] result in
            switch result {
            case .success(let requestToken):
                self?.validateToken(with: requestToken.requestToken,
                                    login: login,
                                    password: password,
                                    completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
        
    // MARK: - Private Methods

    private func validateToken(with requestToken: String,
                               login: String,
                               password: String,
                               completion: @escaping (Result) -> Void) {
        let endpoint = ValidateTokenEndpoint(with: login, password: password, requestToken: requestToken)
        client.request(endpoint) { [weak self] result in
            switch result {
            case .success(let validatedToken):
                self?.createSessionId(with: validatedToken, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func createSessionId(with validatedToken: ValidateToken,
                                 completion: @escaping (Result) -> Void) {
        let endpoint = SessionEndpoint(with: validatedToken.requestToken)
        client.request(endpoint) { [weak self] result in
            switch result {
            case .success(let sessionResult):
                guard let sessionId = sessionResult.sessionId else {
                    completion(.failure(ServiceError.invalidSessionIdResponse))
                    return
                }
                completion(.success(sessionResult))
                let credentials = UserSessionData(token: validatedToken.requestToken,
                                                  expires: validatedToken.expiresAt,
                                                  session: sessionId)
                self?.accessService.credentials = credentials
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
