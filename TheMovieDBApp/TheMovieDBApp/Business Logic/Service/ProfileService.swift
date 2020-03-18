//
//  ProfileService.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 17.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.

import Foundation
import TMDBNetwork

protocol ProfileService {
    
    /// Метод получения данных пользователя
    ///
    /// - Parameter completion: обработчик данных профиля
    func getUserInfo(completion: @escaping (APIResult<Profile>) -> Void)
}

/// Сервис авторизации пользователя.
/// Позволяет создать и сохранить пользовательскую сессию
final public class UserProfileService: ProfileService {
    
    // MARK: - Types
    
    typealias Result = APIResult<Profile>
    
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
    
    func getUserInfo(completion: @escaping (Result) -> Void) {
        
        guard let session = accessService.credentials?.session else {
            return
        }
        // TODO: - проверка в кэше картинок профиля
        let endpoint = ProfileEndpoint(sessionId: session)
        client.request(endpoint) { result in
            switch result {
            case .success(let profileDTO):
                self.getAvatar(hash: profileDTO.avatar?.gravatar?.hash,
                               name: profileDTO.name,
                               username: profileDTO.username, completion: completion)
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func getAvatar(hash: String?, name: String, username: String, completion: @escaping (Result) -> Void) {
        guard let hash = hash else { return }
        
        let config = APIClientConfig(base: "https://secure.gravatar.com/avatar/")
        let imageClient = TMDBAPIClient(config: config)
        let endpoint = GravatarEndpoint(hash: hash)
        imageClient.request(endpoint) { result in
            switch result {
            case .success(let imageDTO):
                let userProfile = Profile(name: name, username: username, image: imageDTO)
                completion(.success(userProfile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}