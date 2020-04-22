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
                                          height: 95)
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
            // TODO: - профиль с фоточкой 
            profileViewController.set(profile: "Denis Nefedov")
        case let .setup(step):
            if step == 1 {
                profileViewController.set(profile: "Придумайте пин-код\nдля быстрого входа")
            } else {
                profileViewController.set(profile: "Повторите\nваш пин-код")
            }
        }
    }
    
    func getPinCode() -> String {
        "1234" // TODO: - loader
    }
    
    func pinCodeDidUnlock() {
        UIApplication.setRootView(storyAssembler.makeTabBar())
    }
    
    func exit() {
        pinCodeLoader?.logout()
        UIApplication.setRootView(
            UINavigationController(rootViewController: storyAssembler.makeAuthStory()))
    }
}
