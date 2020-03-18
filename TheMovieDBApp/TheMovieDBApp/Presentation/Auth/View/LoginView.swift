//
//  LoginView.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 06.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

protocol LoginViewDelegate: class {
    
    /// Метод обработки нажатия логина
    func loginAction()
}

final class LoginView: XibView {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subHeaderLabel: UILabel!
    @IBOutlet weak var loginTextField: TMDBTextField!
    @IBOutlet weak var passwordTextField: TMDBTextField!
    @IBOutlet weak var loginButton: TMDBButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - Public Properties
    
    weak var delegate: LoginViewDelegate!
        
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Public methods
    
    
    /// Метод настройки вьюшки
    func setup() {
        contentView.backgroundColor = ColorName.background
        setupLoginTextField()
        setupPasswordTextField()
    }
    
    /// Метод сброса полей
    func resetFields() {
        loginTextField.text = ""
        passwordTextField.text = ""
        loginButton.isEnabled = false
    }
    
    /// Метод выставляет ошибку в лейбле
    /// - Parameter message: ошибка
    func setErrorLabel(with message: String) {
        errorLabel.text = message
    }
    
    /// Хендлер того, что содержимое поля изменилось
    @objc func textFieldValueChanged(_ textField: UITextField) {
        loginButton.isEnabled = isValid(loginTextField.text ?? "", with: passwordTextField.text ?? "")
    }
                
    // MARK: - IBAction
    
    @IBAction func loginAction(_ sender: Any) {
        delegate.loginAction()
    }
    
    // MARK: - Private Methods
    
    private func setupLoginTextField() {
        loginTextField.delegate = self
        loginTextField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
    }
    
    private func setupPasswordTextField() {
        passwordTextField.setupImage()
        passwordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
    }

}

extension LoginView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = ColorName.borderActive.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = ColorName.borderUnactive.cgColor
    }
}
