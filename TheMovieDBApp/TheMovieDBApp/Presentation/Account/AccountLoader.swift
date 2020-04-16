//
//  AccountLoader.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

protocol AccountLoader {
    
    /// Удаляем пользовательские данные
    func deleteAccountData() throws
    
    /// Обновление профиля при загрузке экрана
    func updateProfile()
}

/// Лоадер-фасад экрана профиля,
/// который скрывает за собой работу других сервисов
final class AccountLoaderImpl: AccountLoader {
    
    // MARK: - Private Properties
    
    private var credentailsService: AccessCredentialsService
    private var profileService: ProfileService
    
    private var view: AccountViewInput
    
    // MARK: - Initializers
    
    init(_ view: AccountViewInput,
         credentailsService: AccessCredentialsService,
         profileService: ProfileService
    ) {
        self.view = view
        self.credentailsService = credentailsService
        self.profileService = profileService
    }
        
    // MARK: - Public methods
    
    func deleteAccountData() throws {
        try credentailsService.delete()
        profileService.logout()
    }
    
    /// Обновление профиля при загрузке экрана
    func updateProfile() {
        
        self.view.showProgress()
        
        profileService.userInfo { [weak self] result in
            DispatchQueue.main.async {
                
                self?.view.hideProgress()
                
                switch result {
                case .success(let profile):
                    self?.view.setRemoteProfileData(profile: profile)
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
}
