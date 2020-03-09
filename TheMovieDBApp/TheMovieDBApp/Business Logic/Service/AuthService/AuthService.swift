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
    case failure(Error)
}

protocol AuthService {
    // TODO: - signout
    func signInUser(with login: String, password: String, completion: @escaping (LoginServiceResult) -> Void)
}

/**
 Сервис авторизации пользователя.
 Позволяет создать и сохранить пользовательскую сессию
 */
public class LoginService: AuthService {
    private var accessService: AccessCredentialsService
    private let client: AuthClient
    
    typealias Result = LoginServiceResult
    
    init(client: AuthClient, accessService: AccessCredentialsService) {
        self.client = client
        self.accessService = accessService
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    /// Метод авторизации пользователя
    /// - Parameter login: логин пользователя
    /// - Parameter password: пароль пользователя
    /// - Parameter completion: обработчик авторизации или ошибки авторизации
    func signInUser(with login: String, password: String, completion: @escaping (Result) -> Void) {
        client.createRequestToken { result in
            switch result {
            case .success(let requestToken):
                self.validateToken(with: requestToken.token, login: login, password: password, completion: completion)
            case .failure(let error):
                print(error.description)
                completion(.failure(error))
            }
        }
    }
    
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
        client.createSessionId(with: requestToken.token) { result in
            switch result {
            case .success(let sessionResult):
                guard let sessionId = sessionResult.sessionId else { return }
                    print(sessionId)
                completion(.success(sessionResult))
                let credentials = UserSessionData(token: requestToken.token,
                                                  expiers: requestToken.expiersAt,
                                                  session: sessionResult.sessionId ?? "")
                self.accessService.credentials = credentials
//                self.getAccountDetails(sessionId, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
