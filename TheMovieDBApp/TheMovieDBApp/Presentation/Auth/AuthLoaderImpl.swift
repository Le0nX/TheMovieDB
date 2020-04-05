//
//  AuthPresenter.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 08.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

protocol AuthLoader {
    
    /// Метод обработки нажатия кнопки Login
    /// - Parameter login: логин пользователя
    /// - Parameter password: пароль паользователя
    func didPressedLoginButton(login: String, password: String)
}

/// Класс перезентации экрана' Auth
final class AuthLoaderImpl: AuthLoader {
    
    // MARK: - Private Properties
    
    private var view: AuthViewInput
    private var authService: AuthService
    
    // MARK: - Initializers

    init(_ view: AuthViewInput, authService: AuthService) {
        self.view = view
        self.authService = authService
    }
    
    // MARK: - Public methods
    
    /// Метод обработки нажатия кнопки Login
    /// - Parameter login: логин пользователя
    /// - Parameter password: пароль паользователя
    func didPressedLoginButton(login: String, password: String) {
        
        self.view.showProgress()
        
        self.authService.signInUser(with: login, password: password) { [weak self] result in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                
                self.view.hideProgress()
                
                switch result {
                case .failure(let error):
                    self.view.showError(with: error.localizedDescription)
                case .success:
                    self.view.showMainScreen()
                }
            }
        }
    }
}
