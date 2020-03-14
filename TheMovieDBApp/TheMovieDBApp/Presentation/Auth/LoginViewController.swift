//
//  ViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 06.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

protocol AuthViewInput {
    
    /// Метод отображения ошибки
    /// - Parameter error: текст ошибки
    func showError(with error: String)
    
    /// Метод показа спиннера
    func showProgress()
    
    /// Метод скрытия спиннера
    func hideProgress()
}

final class LoginViewController: UIViewController {
    
    // MARK: - Constants
    
    private let containerView: LoginView
        
    // MARK: - Public Properties
    
    public var output: AuthPresenterOutput?
        
    // MARK: - Initializers
    
    init(_ view: LoginView = LoginView()) {
        self.containerView = view
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
}

extension LoginViewController: AuthViewInput {
    
    func showProgress() {
        self.showSpinner(onView: self.view)
    }
    
    func hideProgress() {
        self.removeSpinner()
    }
    
    func showError(with error: String) {
        containerView.setErrorLabel(with: error)
        containerView.errorLabel.isHidden = false
    }
}

extension LoginViewController: LoginViewDelegate {
    func loginAction() {
        
        output?.didPressedLoginButton(login: containerView.loginTextField.text ?? "",
                                      password: containerView.passwordTextField.text ?? "")
        containerView.errorLabel.isHidden = true
    }
}
