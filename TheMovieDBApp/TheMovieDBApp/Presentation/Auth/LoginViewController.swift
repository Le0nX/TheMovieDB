//
//  ViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 06.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: class {
    
    /// Метод аутентификации с данными пользователя
    /// - Parameter data: логин/пароль
    func loginWith(data: LoginModel)
}

final class LoginViewController: UIViewController {
    
    // MARK: - Constants
    
    private let containerView = LoginView()
        
    // MARK: - Public Properties
    
    public weak var delegate: LoginViewControllerDelegate?
    
    // MARK: - UIViewController(*)
    
    override func loadView() {
        super.loadView()
        self.view = self.containerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        
        containerView.delegate = self
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Public Methods
    
    /// Показать ошибку авторизации
    /// - Parameter error: описание ошибки
    func setError(with error: String) {
        containerView.setErrorLabel(with: error)
        containerView.shakeLastActiveTextField()
    }
    
}

extension LoginViewController: LoginViewDelegate {
    func loginAction() {
        containerView.animateLoginButtonPress()
        delegate?.loginWith(data: LoginModel(login: containerView.loginField,
                                             password: containerView.passwordField))
        containerView.hideError()
    }
}
