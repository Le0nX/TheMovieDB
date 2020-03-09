//
//  StoryAssembler.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 08.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

protocol StorysAssembler {
    func makeAuthStory() -> LoginViewController
}

class StoryFabric: StorysAssembler {
    
    private let servicesAssembler: ServicesAssembler
    
    init(servicesAssembler: ServicesAssembler) {
        self.servicesAssembler = servicesAssembler
    }
    
    /// Фабричный метод создания экрана авторизации
    func makeAuthStory() -> LoginViewController {
        let loginVc = LoginViewController()
        loginVc.output = AuthPresenter(loginVc, authService: servicesAssembler.authService)
        
        return loginVc
    }
    
    /// Фабричный метод создания экрана авторизации
    func makeTabBar() -> UITabBarController {
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

        return tabBar
    }
}
