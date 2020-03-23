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
    
    private var view: AccountViewInput
    
    // MARK: - Initializers
    
    init(_ view: AccountViewInput,
         credentailsService: AccessCredentialsService,
         profileService: ProfileService,
         accountCoordinator: AccountCoordinator
    ) {
        self.view = view
        self.credentailsService = credentailsService
        self.profileService = profileService
        self.accountCoordinator = accountCoordinator
    }
        
    // MARK: - Public methods
    
    func didPressedLogoutButton() {
        try? credentailsService.delete()
        accountCoordinator.start()
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
