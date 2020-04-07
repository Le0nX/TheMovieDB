//
//  MainPinCodeViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 07.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

final class MainPinCodeViewController: UIViewController {

    // MARK: - Private Properties
    
    private let profileViewController = ProfileViewController()
    private let pinCodeViewController = PinCodeViewController()
        
    // MARK: - UIViewController(*)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorName.background
        
        addProfileVC()
        addPincodeVC()
    }
    
    // MARK: - Private Methods
    
    private func addProfileVC() {
        add(profileViewController)
        profileViewController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil,
                                          right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0,
                                          paddingRight: 0, width: 0,
                                          height: 95)
    }
    
    private func addPincodeVC() {
        add(pinCodeViewController)
        pinCodeViewController.view.anchor(top: profileViewController.view.bottomAnchor,
                                          left: view.leftAnchor, bottom: view.bottomAnchor,
                                          right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0,
                                          paddingRight: 0, width: 0, height: 0)
    }

}
