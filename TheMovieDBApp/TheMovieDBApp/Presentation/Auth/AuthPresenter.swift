//
//  AuthPresenter.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 08.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

protocol AuthPresenterOutput {
    func didPressedLoginButton(login: String, password: String)
}

final class AuthPresenter: AuthPresenterOutput {

    private weak var view: AuthViewInput!
    private var authService: AuthService!
    private var authCoordinator: Coordinator!
    
    init(_ view: AuthViewInput, authService: AuthService, authCoordinator: Coordinator) {
        self.view = view
        self.authService = authService
        self.authCoordinator = authCoordinator
    }
    
    func didPressedLoginButton(login: String, password: String) {
        
        self.view.showProgress()
        
        self.authService.signInUser (with: login, password: password) { [weak self] result in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                
                self.view.hideProgress()
                
                switch result {
                case .failure(let error):
                    self.view.showError(with: error.localizedDescription)
                case .success(let data):
                    self.authCoordinator.start()
                }
            }
        }
    }
}
