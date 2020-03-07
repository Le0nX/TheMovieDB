//
//  AccountViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 08.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

final class AccountViewController: UIViewController {
    private let containerView: AccountView
       
    init(_ view: AccountView = AccountView()) {
        self.containerView = view
        super.init(nibName: nil, bundle: nil)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func loadView() {
        super.loadView()
        self.view = self.containerView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.navigationItem.hidesBackButton = true

        self.hideKeyboardWhenTappedAround()
    }
}
