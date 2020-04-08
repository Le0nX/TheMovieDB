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
    
    @IBOutlet private var headerLabel: UILabel!
    @IBOutlet private var subHeaderLabel: UILabel!
    @IBOutlet var loginTextField: TMDBTextField!
    @IBOutlet var passwordTextField: TMDBTextField!
    @IBOutlet var loginButton: TMDBButton!
    @IBOutlet var errorLabel: UILabel!
    
    // MARK: - Public Properties
    
    weak var delegate: LoginViewDelegate?
    
    // MARK: - Private Properties
    
    var lastActiveTextField: TMDBTextField?
        
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
    
    /// Метод анимации ошибки последнего активно поля ввода
    func shakeLastActiveTextField() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        lastActiveTextField?.layer.add(animation, forKey: "shake")
    }
    
    /// Метод анимации кнопки логина
    func animateLoginButtonPress() {
        self.loginButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: {
                        self.loginButton.transform = .identity
                        },
                       completion: nil)
    }
                
    // MARK: - IBAction
    
    @IBAction func loginAction(_ sender: Any) {
        delegate?.loginAction()
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
        lastActiveTextField = textField as? TMDBTextField
        textField.layer.borderColor = ColorName.borderActive.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        lastActiveTextField = textField as? TMDBTextField
        textField.layer.borderColor = ColorName.borderUnactive.cgColor
    }
}
