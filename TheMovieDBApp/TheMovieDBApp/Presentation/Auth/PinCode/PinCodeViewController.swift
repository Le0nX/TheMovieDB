//
//  NumPadViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 07.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

protocol PinCodeViewControllerDelegate: class {
    func update(state: MainPinCodeViewController.State)
    
    func getPinCode() -> String
    
    func pinCodeDidUnlock()
    
    func exit()
}

/// ViewConrtoller экрана пинкода
final class PinCodeViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var delegate: PinCodeViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private let containerView = PinCodeView()
    private let state: MainPinCodeViewController.State
    
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
    func getPinCode() -> String {
        delegate?.getPinCode() ?? ""
    }
    
    func update(state: MainPinCodeViewController.State) {
        delegate?.update(state: state)
    }
    
    func pinCodeDidUnlock() {
        delegate?.pinCodeDidUnlock()
    }
    
    func exit() {
        delegate?.exit()
    }
}
