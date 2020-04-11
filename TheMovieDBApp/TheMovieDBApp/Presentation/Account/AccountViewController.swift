//
//  AccountViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 08.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

protocol AcocuntViewControllerDelegate: class {
    
    /// Обработка нажатия кнопки разлогина
    func didPressedLogout()
}

/// ViewController профиля
final class AccountViewController: UIViewController {
        
    // MARK: - Constants
    
    private let containerView: AccountView
        
    // MARK: - Public Properties
    
    public weak var delegate: AcocuntViewControllerDelegate?
        
    // MARK: - Initializers
    
    init(_ view: AccountView = AccountView()) {
         self.containerView = view
         super.init(nibName: nil, bundle: nil)
     }
    
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    // MARK: - UIViewController(*)
    
    override func loadView() {
        super.loadView()
        
        containerView.delegate = self
        self.view = self.containerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.navigationItem.hidesBackButton = true

        self.hideKeyboardWhenTappedAround()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Public Mthods
    
    /// Метод установки данных пользователя пришедших по сети
    /// - Parameter profile: модель профиля
    func setRemoteProfileData(profile: Profile) {
        self.containerView.nameLabel.text = profile.name
        self.containerView.usernameLabel.text = profile.username
        self.containerView.avatarImage.image = UIImage(data: profile.image)
    }
}

extension AccountViewController: AccountViewDelegate {
    func showPinCodeVC() {
        navigationController?.pushViewController(MainPinCodeViewController(), animated: true)
    }
    
    func logout() {
        delegate?.didPressedLogout()
    }
}
