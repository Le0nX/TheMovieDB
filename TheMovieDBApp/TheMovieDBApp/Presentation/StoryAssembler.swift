//
//  StoryAssembler.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 08.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

protocol StoriesAssembler {
    
    /// Фабричный метод создания экрана логина
    func makeAuthStory() -> LoginViewController
    
    /// Фабричный метод создания таббара
    func makeTabBar() -> UITabBarController
    
    /// Фабричный метод создания экрана профиля
    func makeAccountStory() -> AccountViewController
    
    /// Фабричный метод создания экрана поиска
    func makeSearchStory() -> MainSearchViewController
    
    /// Фабричный метод создания экрана фаворитов
    func makeFavoritesStory() -> MainFavoritesViewController
}

final class StoryFabric: StoriesAssembler {
    
    // MARK: - Private Properties
    
    private let servicesAssembler: ServicesAssembler
    
    // MARK: - Initializers
    
    init(servicesAssembler: ServicesAssembler) {
        self.servicesAssembler = servicesAssembler
    }
        
    // MARK: - Public methods
    
    /// Фабричный метод создания экрана авторизации
    func makeAuthStory() -> LoginViewController {
        let loginVc = LoginViewController()
        let authCoordinator = AuthCoordinator(storyAssembler: self)
        loginVc.output = AuthPresenter(WeakRef(loginVc),
                                       authService: servicesAssembler.authService,
                                       authCoordinator: authCoordinator)
        
        return loginVc
    }
    
    func makeFavoritesStory() -> MainFavoritesViewController {
        let mainFavoritesView = MainFavoritesViewController()
        mainFavoritesView.loader = FavoritesLoader(WeakRef(mainFavoritesView),
                                                   favoriteService: servicesAssembler.favoriteService)
        
        return mainFavoritesView
    }
    
    /// Фабричный метод создания экрана авторизации
    func makeTabBar() -> UITabBarController {
        let firstViewController = UINavigationController(rootViewController: makeSearchStory())
        firstViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("FILMS_ICON", comment: "Фильмы"),
                                                      image: ImageName.filmIcon,
                                                      tag: 0)

        let secondViewController = UINavigationController(rootViewController: makeFavoritesStory())
        secondViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("FAVORITES_ICON", comment: "Избранное"),
                                                       image: ImageName.favoriteIcon,
                                                       tag: 1)

        let thirdViewController = UINavigationController(rootViewController: makeAccountStory())
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
        accountVc.output = AccountPresenter(WeakRef(accountVc),
                                            credentailsService: servicesAssembler.accessService,
                                            profileService: servicesAssembler.profileService,
                                            accountCoordinator: accountCoordinator)
        
        return accountVc
    }
    
    /// Фабричный метод создания экрана поиска
    func makeSearchStory() -> MainSearchViewController {
        let mainSearchView = MainSearchViewController()
        mainSearchView.output = SearchPresenter(WeakRef(mainSearchView),
                                                moviesService: servicesAssembler.movieService)
        
        return mainSearchView
    }
}
