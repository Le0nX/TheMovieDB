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
    // MARK: - Outlets
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subHeaderLabel: UILabel!
    @IBOutlet weak var loginTextField: TMDBTextField!
    @IBOutlet weak var passwordTextField: TMDBTextField!
    @IBOutlet weak var loginButton: TMDBButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    weak var delegate: LoginViewDelegate!
    
    // MARK: - Constructors
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - View setupers
    func setup() {
        contentView.backgroundColor = ColorName.background
        setupLoginTextField()
        setupPasswordTextField()
    }
    
    func resetFields() {
        loginTextField.text = ""
        passwordTextField.text = ""
        loginButton.isEnabled = false
    }
    
    func setErrorLabel(with message: String) {
        errorLabel.text = message
    }
    
    /// Хендлер того, что содержимое поля изменилось
    /// Проверяет валидацию данных
    /// - Parameter textField: поле, откуда поступили изменения
    @objc func textFieldValueChanged(_ textField: UITextField) {
        // TODO: - переделать
        let firstCond = loginTextField.text?.count ?? 0 > 2
        let secondCond = passwordTextField.text?.count ?? 0 > 2
        let thirdRule = true
        
        //thirdRule = isValidEmail(emailStr: loginTextField.text ?? "")

        loginButton.isEnabled = (
            firstCond && secondCond && thirdRule
        )
    }
        
    // MARK: - IBActions
    @IBAction func loginAction(_ sender: Any) {
        delegate.loginAction()
    }
    
    // MARK: - Private methods
    /// Валидация email'a с помощью regex
    /// За основу взят https://emailregex.com/
    /// - Parameter emailStr: email
    private func isValidEmail(emailStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
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
