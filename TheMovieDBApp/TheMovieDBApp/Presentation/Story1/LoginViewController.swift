//
//  ViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 06.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    private let containerView: LoginView
    
    init(_ view: LoginView = LoginView()) {
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
        
        containerView.output = self
        
        self.hideKeyboardWhenTappedAround()
    }

}

extension LoginViewController: LoginViewOutput {
    func login() {
        
        containerView.resetFields()
        
        let firstViewController = SearchViewController()
        firstViewController.tabBarItem = UITabBarItem(title: "Фильмы", image: ImageName.filmIcon, tag: 0)

        let secondViewController = FavoritesViewController()
        secondViewController.tabBarItem = UITabBarItem(title: "Избранное", image: ImageName.favoriteIcon, tag: 1)
        
        let thirdViewController = AccountViewController()
        thirdViewController.tabBarItem = UITabBarItem(title: "Профиль", image: ImageName.accountIcon, tag: 2)

        let tabBarList = [firstViewController, secondViewController, thirdViewController]
        
        let tabBar = UITabBarController()
        tabBar.viewControllers = tabBarList
        tabBar.navigationItem.hidesBackButton = true
        
        self.navigationController?.pushViewController(tabBar, animated: true)
    }
}
