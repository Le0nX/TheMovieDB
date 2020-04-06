//
//  MainAccountViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 06.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

import UIKit

protocol AccountViewInput {
    
    /// Метод выставления данных профиля на экране
    /// - Parameter profile: DTO профиля
    func setRemoteProfileData(profile: Profile)
    
    /// Показать спиннер на экране
    func showProgress()
    
    /// Скрыть спиннер
    func hideProgress()
}

final class MainAccountViewController: UIViewController {
    
    // MARK: - Public Properties
    
    public var loader: AccountLoader?
    
    // MARK: - Private Properties
    
    private let accountViewController = AccountViewController()
    private let storyAssembler: StoriesAssembler
    
    // MARK: - Initializers
    
    init(storyAssembler: StoriesAssembler) {
        self.storyAssembler = storyAssembler
        super.init(nibName: nil, bundle: nil)
     }
    
     required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
     }
        
    // MARK: - UIViewController(*)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountViewController.delegate = self
        addAccountVC()
        
        loader?.updateProfile()
    }
    
    // MARK: - Private Methods
    
    private func addAccountVC() {
        add(accountViewController)
        accountViewController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,
                                          right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0,
                                          paddingRight: 0, width: 0, height: 0)
    }

}

extension MainAccountViewController: AccountViewInput {
    
    func showProgress() {
        self.showSpinner(onView: view)
    }
    
    func hideProgress() {
        self.removeSpinner()
    }
    
    func setRemoteProfileData(profile: Profile) {
        accountViewController.setRemoteProfileData(profile: profile)
    }
}

extension MainAccountViewController: AcocuntViewControllerDelegate {
    func didPressedLogout() {
        try? loader?.deleteAccountData() 
        UIApplication.setRootView(UINavigationController(rootViewController: storyAssembler.makeAuthStory()))
    }
}
