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
    func makeAuthStory() -> MainAuthViewController
    
    /// Фабричный метод создания таббара
    func makeTabBar() -> UITabBarController
    
    /// Фабричный метод создания экрана профиля
    func makeAccountStory() -> MainAccountViewController
    
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
    func makeAuthStory() -> MainAuthViewController {
        let loginVc = MainAuthViewController(storyAssembler: self)
        loginVc.loader = AuthLoaderImpl(WeakRef(loginVc),
                                        authService: servicesAssembler.authService)
        
        return loginVc
    }
    
    func makeFavoritesStory() -> MainFavoritesViewController {
        let mainFavoritesView = MainFavoritesViewController(imageLoader: servicesAssembler.imageLoader())
        mainFavoritesView.loader = FavoritesLoaderImpl(WeakRef(mainFavoritesView),
                                                       favoriteService: servicesAssembler.favoriteService,
                                                       accessService: servicesAssembler.accessService)
        
        return mainFavoritesView
    }
    
    /// Фабричный метод создания tabBar'a
    func makeTabBar() -> UITabBarController {
        let search = makeTabBarNavigationControllerItem(
                                                    makeSearchStory(),
                                                    title: NSLocalizedString("FILMS_ICON", comment: "Фильмы"),
                                                    image: ImageName.filmIcon,
                                                    tag: 0)

        let favorites = makeTabBarNavigationControllerItem(
                                                    makeFavoritesStory(),
                                                    title: NSLocalizedString("FAVORITES_ICON", comment: "Избранное"),
                                                    image: ImageName.favoriteIcon,
                                                    tag: 1)

        let account = makeTabBarNavigationControllerItem(
                                                    makeAccountStory(),
                                                    title: NSLocalizedString("ACCOUNT_ICON", comment: "Профиль"),
                                                    image: ImageName.accountIcon,
                                                    tag: 2)
           
        let tabBarList = [search, favorites, account]

        let tabBar = UITabBarController()
        tabBar.viewControllers = tabBarList
        tabBar.navigationItem.hidesBackButton = true

        return tabBar
    }
    
    /// Фабричный метод создания экрана профиля
    func makeAccountStory() -> MainAccountViewController {
        let accountVc = MainAccountViewController(storyAssembler: self)
        accountVc.loader = AccountLoaderImpl(WeakRef(accountVc),
                                             credentailsService: servicesAssembler.accessService,
                                             profileService: servicesAssembler.profileService)
        
        return accountVc
    }
    
    /// Фабричный метод создания экрана поиска
    func makeSearchStory() -> MainSearchViewController {
        let mainSearchView = MainSearchViewController(imageLoader: servicesAssembler.imageLoader())
        mainSearchView.loader = SearchLoaderImpl(WeakRef(mainSearchView),
                                                 favoriteService: servicesAssembler.favoriteService,
                                                 moviesService: servicesAssembler.movieService,
                                                 accessService: servicesAssembler.accessService)
        
        return mainSearchView
    }
    
    private func makeTabBarNavigationControllerItem(_ viewController: UIViewController,
                                                    title: String?,
                                                    image: UIImage?,
                                                    tag: Int) -> UIViewController {
        let vc = UINavigationController(rootViewController: viewController)
        vc.tabBarItem = UITabBarItem(title: title, image: image, tag: tag)
        
        return vc
    }
}
