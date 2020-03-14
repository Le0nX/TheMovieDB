//
//  AccountViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 08.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

final class AccountViewController: UIViewController {
        
    // MARK: - Constants
    
    private let containerView: AccountView
        
    // MARK: - Public Properties
    
    public var output: AccountPresenter?
        
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
        containerView.output = self
        
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
}

extension AccountViewController: AccountViewOutput {
    func logout() {
        self.output?.didPressedLogoutButton()
    }
}
