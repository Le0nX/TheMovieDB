//
//  LoginView.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 06.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

class LoginView: XibView {
    // MARK: - Outlets
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subHeaderLabel: UILabel!
    @IBOutlet weak var loginTextField: TMDBTextField!
    @IBOutlet weak var passwordTextField: TMDBTextField!
    @IBOutlet weak var loginButton: UIButton!
    
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
    
    private func setupLoginTextField() {
        loginTextField.delegate = self
        loginTextField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
    }
    
    private func setupPasswordTextField() {
        passwordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
    }
    
    @objc
    func textFieldValueChanged(_ textField: UITextField) {
        let firstCond = !loginTextField.isEmpty
        let secondCond = !passwordTextField.isEmpty
        var thirdRule = false
        
        thirdRule = isValidEmail(emailStr: loginTextField.text ?? "")

        loginButton.isEnabled = (
            firstCond && secondCond && thirdRule
        )
    }
    
    func isValidEmail(emailStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    // MARK: - IBActions
    @IBAction func loginAction(_ sender: Any) {
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
