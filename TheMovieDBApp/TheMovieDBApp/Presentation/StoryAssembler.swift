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
    func makeTabBar() -> UITabBarController
    func makeAccountStory() -> AccountViewController
}

class StoryFabric: StorysAssembler {
    
    private let servicesAssembler: ServicesAssembler
    
    init(servicesAssembler: ServicesAssembler) {
        self.servicesAssembler = servicesAssembler
    }
    
    /// Фабричный метод создания экрана авторизации
    func makeAuthStory() -> LoginViewController {
        let loginVc = LoginViewController()
        let authCoordinator = AuthCoordinator(storyAssembler: self)
        loginVc.output = AuthPresenter(loginVc,
                                       authService: servicesAssembler.authService,
                                       authCoordinator: authCoordinator)
        
        return loginVc
    }
    
    /// Фабричный метод создания экрана авторизации
    func makeTabBar() -> UITabBarController {
        let firstViewController = SearchViewController()
        firstViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("FILMS_ICON", comment: "Фильмы"),
                                                      image: ImageName.filmIcon,
                                                      tag: 0)

        let secondViewController = FavoritesViewController()
        secondViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("FAVORITES_ICON", comment: "Избранное"),
                                                       image: ImageName.favoriteIcon,
                                                       tag: 1)

        let thirdViewController = makeAccountStory()
        thirdViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("ACCOUNT_ICON", comment: "Профиль"),
                                                      image: ImageName.accountIcon,
                                                      tag: 2)

        let tabBarList = [firstViewController, secondViewController, thirdViewController]

        let tabBar = UITabBarController()
        tabBar.viewControllers = tabBarList
        tabBar.navigationItem.hidesBackButton = true

        return tabBar
    }
    
    /// Фабричный метод создания экрана профиля
    func makeAccountStory() -> AccountViewController {
        let accountVc = AccountViewController()
        let accountCoordinator = AccountCoordinator(storyAssembler: self)
        accountVc.output = AccountPresenter(credentailsService: servicesAssembler.accessService,
                                            accountCoordinator: accountCoordinator)
        
        return accountVc
    }
}
