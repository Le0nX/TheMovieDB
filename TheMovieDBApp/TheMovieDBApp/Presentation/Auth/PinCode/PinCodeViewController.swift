//
//  NumPadViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 07.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

protocol PinCodeViewControllerDelegate: class {
    
    /// Обновление состояния экрана пинкода
    func update(state: MainPinCodeViewController.State)
    
    /// Пинкод разлочил экран
    /// - Parameters:
    ///   - pin: пинкод
    ///   - view: вью пинкода
    func pinCodeDidUnlock(with pin: String, _ view: PinCodeView)
    
    /// Пиинкод был задан
    /// - Parameter pin: пинкод
    func pinCodeDidSet(with pin: String)
    
    /// Попытка авторизации по биометрии
    func biometryDidUnlock()
    
    /// Обработка ответа из сервиса авторизации по биометрии
    /// - Parameter completion: хендлер
    func bioAuth(completion: @escaping (Bool) -> Void)
    
    /// выход
    func exit()
}

/// ViewConrtoller экрана пинкода
final class PinCodeViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var delegate: PinCodeViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private let containerView = PinCodeView()
    private let state: MainPinCodeViewController.State
    
    // MARK: - Initializers
    
    init(with state: MainPinCodeViewController.State) {
        self.state = state
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
        containerView.state = state
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
}

extension PinCodeViewController: PinCodeViewDelegate {
    
    func pinCodeDidSet(with pin: String) {
        delegate?.pinCodeDidSet(with: pin)
    }
    
    func update(state: MainPinCodeViewController.State) {
        delegate?.update(state: state)
    }
    
    func pinCodeDidUnlock(with pin: String, _ view: PinCodeView) {
        delegate?.pinCodeDidUnlock(with: pin, view)
    }
    
    func exit() {
        delegate?.exit()
    }
    
    func bioAuth(completion: @escaping (Bool) -> Void) {
        delegate?.bioAuth(completion: completion)
    }
    
    func biometryDidUnlock() {
        delegate?.biometryDidUnlock()
    }
}
