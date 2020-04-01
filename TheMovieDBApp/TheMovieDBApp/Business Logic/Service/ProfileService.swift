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
    func userInfo(completion: @escaping (APIResult<Profile>) -> Void)
}

/// Сервис данных профиля пользователя.
/// Позволяет получить аватарку и содержимое профиля
final public class UserProfileService: ProfileService {
    
    // MARK: - Types
    
    typealias Result = APIResult<Profile>
    
    // MARK: - Constants
    
    private let client: APIClient
    private let imageClient: APIClient
            
    // MARK: - Private Properties
    
    private var accessService: AccessCredentialsService
    
    // MARK: - Initializers
    
    init(client: APIClient, imageClient: APIClient, accessService: AccessCredentialsService) {
        self.client = client
        self.imageClient = imageClient
        self.accessService = accessService
    }
    
    // MARK: - Public methods
    
    /// Метод получения данных пользователя
    /// - Parameter completion: обработчик данных профиля
    func userInfo(completion: @escaping (Result) -> Void) {
        
        guard let session = accessService.credentials?.session else {
            return
        }
        let endpoint = ProfileEndpoint(sessionId: session)
        client.request(endpoint) { [weak self] result in
            switch result {
            case .success(let profileDTO):
                self?.fetchAvatar(id: profileDTO.id,
                                  hash: profileDTO.avatar?.gravatar?.hash,
                                  name: profileDTO.name,
                                  username: profileDTO.username, completion: completion)
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private methods
    
    private func fetchAvatar(id: Int,
                             hash: String?,
                             name: String,
                             username: String,
                             completion: @escaping (Result) -> Void) {
        guard let hash = hash else { return }
        
        let endpoint = GravatarEndpoint(hash: hash)
        imageClient.request(endpoint) { result in
            switch result {
            case .success(let imageDTO):
                let userProfile = Profile(id: id, name: name, username: username, image: imageDTO)
                completion(.success(userProfile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
