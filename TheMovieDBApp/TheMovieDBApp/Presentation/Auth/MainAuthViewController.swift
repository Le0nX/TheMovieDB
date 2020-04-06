//
//  MainAuthViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 05.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

protocol AuthViewInput {
    
    /// Методо отображения главного экрана
    /// показыается в случае успешного логина
    func showMainScreen()
    
    /// Метод отображения ошибки
    /// - Parameter error: текст ошибки
    func showError(with error: String)
    
    /// Метод показа спиннера
    func showProgress()
    
    /// Метод скрытия спиннера
    func hideProgress()
}

final class MainAuthViewController: UIViewController {
    
    // MARK: - Public Properties
    
    public var loader: AuthLoader?
    
    // MARK: - Private Properties
    
    private let loginViewController = LoginViewController()
    private let storyAssembler: StoriesAssembler
    
    // MARK: - Initializers
    
    init(storyAssembler: StoriesAssembler) {
        self.storyAssembler = storyAssembler
        super.init(nibName: nil, bundle: nil)
     }
    
     required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
     }
        
    // MARK: - UIViewController(*)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginViewController.delegate = self
        
        addLoginVC()
    }
    
    // MARK: - Private Methods
    
    private func addLoginVC() {
        add(loginViewController)
        loginViewController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,
                                        right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0,
                                        paddingRight: 0, width: 0, height: 0)
    }

}

extension MainAuthViewController: AuthViewInput {
    
    func showMainScreen() {
        UIApplication.setRootView(storyAssembler.makeTabBar())
    }
    
    func showProgress() {
        self.showSpinner(onView: self.view)
    }
    
    func hideProgress() {
        self.removeSpinner()
    }
    
    func showError(with error: String) {
        loginViewController.setError(with: error)
    }
}

extension MainAuthViewController: LoginViewControllerDelegate {
    func loginWith(data: LoginModel) {
        loader?.didPressedLoginButton(login: data.login, password: data.password)
    }
}