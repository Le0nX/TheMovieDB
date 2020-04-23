//
//  MainPinCodeViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 07.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

/// Контейнер ViewController для экрана пинкода
final class MainPinCodeViewController: UIViewController {
    
    // MARK: - Types
    
    /// Текущее состояние экрана пин-кода
    enum State {
        case lock(image: UIImage?) // разблокировка
        case setup(stage: Int)  // настройка с подтверждением пинкода
    }
    
    // MARK: - Pubblic Properties
    
    var pinCodeLoader: PinCodeLoader?

    // MARK: - Private Properties
    
    private let profileViewController = ProfileViewController()
    private let pinCodeViewController: PinCodeViewController
    private let storyAssembler: StoriesAssembler
    private var state: State?
    
    // MARK: - Initializers
    
    init(with state: State, storyAssembler: StoriesAssembler) {
        self.storyAssembler = storyAssembler
        self.state = state
        pinCodeViewController = PinCodeViewController(with: state)
        super.init(nibName: nil, bundle: nil)
     }
    
     required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
     }
        
    // MARK: - UIViewController(*)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorName.background
        
        pinCodeViewController.delegate = self
        
        addProfileViewController()
        addPincodeViewController()
    }
    
    // MARK: - Private Methods
    
    private func addProfileViewController() {
        add(profileViewController)
        profileViewController.view.anchor(top: view.topAnchor,
                                          left: view.leftAnchor,
                                          right: view.rightAnchor,
                                          height: 120)
    }
    
    private func addPincodeViewController() {
        add(pinCodeViewController)
        pinCodeViewController.view.anchor(top: profileViewController.view.bottomAnchor,
                                          left: view.leftAnchor,
                                          bottom: view.bottomAnchor,
                                          right: view.rightAnchor)
    }

}

extension MainPinCodeViewController: PinCodeViewControllerDelegate {
    
    func update(state: MainPinCodeViewController.State) {
        switch state {
        case .lock:
            print("locked")
            pinCodeLoader?.getProfile { [weak self] result in
                switch result {
                case .success(let profileDTO):
                    self?.profileViewController.set(profile: profileDTO)
                case .failure:
                    // TODO: - обработка ошибок
                    print("error")
                }
            }
        case let .setup(step):
            if step == 1 {
                profileViewController.set(text: "Придумайте пин-код\nдля быстрого входа")
            } else {
                profileViewController.set(text: "Повторите\nваш пин-код")
            }
        }
    }
    
    func pinCodeDidUnlock(with pin: String, _ view: PinCodeView) {
        if pinCodeLoader?.check(pinCode: pin) ?? false {
            UIApplication.setRootView(storyAssembler.makeTabBar())
        } else {
            view.fail()
        }
    }
    
    func biometryDidUnlock() {
        UIApplication.setRootView(storyAssembler.makeTabBar())
    }
    
    func pinCodeDidSet(with pin: String) {
        pinCodeLoader?.save(pinCode: pin)
        UIApplication.setRootView(storyAssembler.makePinCodeStory(with: .lock(image: ImageName.faceId)))
//        UIApplication.setRootView(storyAssembler.makeTabBar())
    }
    
    func bioAuth(completion: @escaping(Bool) -> Void) {
        pinCodeLoader?.bioAuth(completion: completion)
    }
    
    func exit() {
        pinCodeLoader?.logout()
        UIApplication.setRootView(
            UINavigationController(rootViewController: storyAssembler.makeAuthStory()))
    }
}
