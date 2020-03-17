//
//  AccountPresenter.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

protocol AccountPresenterOutput {
    
    /// Обработчик нажатия кнопки логаута
    func didPressedLogoutButton()
    
    /// Обновление профиля при загрузке экрана
    func updateProfile()
}

final class AccountPresenter: AccountPresenterOutput {
    
    // MARK: - Private Properties
    
    private var accountCoordinator: AccountCoordinator
    private var credentailsService: AccessCredentialsService
    private var profileService: ProfileService
    
    // MARK: - Initializers
    
    init(credentailsService: AccessCredentialsService,
         profileService: ProfileService,
         accountCoordinator: AccountCoordinator
    ) {
        self.credentailsService = credentailsService
        self.profileService = profileService
        self.accountCoordinator = accountCoordinator
    }
        
    // MARK: - Public methods
    
    func didPressedLogoutButton() {
        try? credentailsService.delete()
        accountCoordinator.start()
    }
    
    func updateProfile() {
        profileService.getUserInfo { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    print(profile)
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
}
