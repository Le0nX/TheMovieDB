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

    // MARK: - Private Properties
    
    private let profileViewController = ProfileViewController()
    private let pinCodeViewController = PinCodeViewController()
        
    // MARK: - UIViewController(*)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorName.background
        
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
