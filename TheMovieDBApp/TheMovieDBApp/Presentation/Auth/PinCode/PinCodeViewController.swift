//
//  NumPadViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 07.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

/// ViewConrtoller экрана пинкода
final class PinCodeViewController: UIViewController {
    
    // MARK: - Constants
    
    private let containerView = PinCodeView()
    
    // MARK: - UIViewController(*)
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
}

extension PinCodeViewController: PinCodeViewDelegate {
    func exit() {
        
    }
    
    func didSelectedFaceId() {
        
    }
    
    func showErrorMessage(_ message: String) {
        
    }
}
