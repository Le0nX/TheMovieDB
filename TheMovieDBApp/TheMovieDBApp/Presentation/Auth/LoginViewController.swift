//
//  ViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 06.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

protocol AuthViewInput: class {
    func showError(with error: String)
    func showProgress()
    func hideProgress()
}

class LoginViewController: UIViewController {

    private let containerView: LoginView!
    
    public var output: AuthPresenterOutput!
    
    init(_ view: LoginView = LoginView()) {
        self.containerView = view
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

}

extension LoginViewController: AuthViewInput {
    func showProgress() {
        self.showSpinner(onView: self.view)
    }
    
    func hideProgress() {
        self.removeSpinner()
    }
    
    func showError(with message: String) {
        containerView.setErrorLabel(with: message)
        containerView.errorLabel.isHidden = false
    }
}

extension LoginViewController: LoginViewDelegate {
    func loginAction() {
        
        output.didPressedLoginButton(login: containerView.loginTextField.text ?? "",
                                     password: containerView.passwordTextField.text ?? "")
        containerView.errorLabel.isHidden = true
    }
}
