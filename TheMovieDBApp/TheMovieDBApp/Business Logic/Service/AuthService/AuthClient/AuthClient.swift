//
//  AuthClient.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

/**
 Класс работы с сетью для авторизации.
 TODO: - добавить logout
 */
class AuthClient: APIClient {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    /// Метод создания request_token
    /// https://developers.themoviedb.org/3/authentication/create-request-token
    /// - Parameter completion: обработчик, который возвращает дженерик результат: .success(RequestToken) или .failure(APIError)
    func createRequestToken(completion: @escaping (Result<RequestToken, APIError>) -> Void) {
        fetch(with: AuthProvider.createRequestToken.request, decode: { json -> RequestToken? in
            guard let requestToken = json as? RequestToken else { return nil }
            return requestToken
        }, completion: completion)
    }

    /// Метод валидации request_token на основе логина и пароля
    /// https://developers.themoviedb.org/3/authentication/validate-request-token
    /// - Parameter requestToken: токен, который был получен ранее с помощью createRequestToken()
    /// - Parameter login: логин пользователя
    /// - Parameter password: пароль пользователя
    /// - Parameter completion: обработчик, который возвращает  результат: .success(валидированный RequestToken) или .failure(APIError)
    func validateRequestToken(with requestToken: String,
                              login: String,
                              password: String,
                              completion: @escaping (Result<RequestToken, APIError>) -> Void) {
        fetch(with: AuthProvider.validateRequestToken(username: login,
                                                      password: password,
                                                      requestToken: requestToken).request,
                                                      decode: { json -> RequestToken? in
            guard let requestToken = json as? RequestToken else { return nil }
            return requestToken
        }, completion: completion)
    }

    /// Метод создания session_id
    /// https://developers.themoviedb.org/3/authentication/create-session
    /// - Parameter requestToken: валидированный request_token из validateRequestToken()
    /// - Parameter completion: обработчик, который возвращает  результат: .success(UserSession) или .failure(APIError)
    func createSessionId(with requestToken: String, completion: @escaping (Result<UserSession, APIError>) -> Void) {
        fetch(with: AuthProvider.createSessionId(requestToken: requestToken).request, decode: { json -> UserSession? in
            guard let sessionResult = json as? UserSession else { return nil }
            return sessionResult
        }, completion: completion)
    }
}
