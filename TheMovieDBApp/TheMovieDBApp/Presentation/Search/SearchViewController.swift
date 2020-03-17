//
//  SearchViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 07.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let containerView: SearchView
    private var isSearching = false
    
    // MARK: - Initializers
    
    init(_ view: SearchView = SearchView()) {
         self.containerView = view
         super.init(nibName: nil, bundle: nil)
     }
    
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    // MARK: - UIViewController(*)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containerView.searchTextField.addTarget(self,
                                                action: #selector(textFieldEditingDidChange(textField:)),
                                                for: .editingChanged)
        containerView.searchTextField.addTarget(self,
                                                action: #selector(textFieldShouldClear(textField:)),
                                                for: .editingDidEnd)
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.containerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.tabBarController?.tabBar.isHidden = true

        self.hideKeyboardWhenTappedAround()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Public Mehtods
    
    @objc
    func textFieldEditingDidChange(textField: UITextField) {
        if isSearching { return }
        
        isSearching = true
        UIView.animate(withDuration: 0.5) {
            self.containerView.headerLabel.alpha = 0
            self.containerView.imageView.alpha = 0
            self.containerView.topConstraint.constant -= 150
            self.containerView.tableView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    func textFieldShouldClear(textField: UITextField) {
        if !isSearching { return }
        
        isSearching = false
        UIView.animate(withDuration: 0.5) {
            self.containerView.headerLabel.alpha = 1
            self.containerView.imageView.alpha = 1
            self.containerView.topConstraint.constant += 150
            self.containerView.tableView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
}
