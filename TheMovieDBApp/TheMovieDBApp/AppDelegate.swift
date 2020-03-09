//
//  AppDelegate.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 06.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        ApplicationAppearance.setupNavigatioBar()
        ApplicationAppearance.setupTabBar()
        
        let serviceAssembler = ServiceFabric()
        let storyAssembler = StoryFabric(servicesAssembler: serviceAssembler)
        
        let credentialsService = serviceAssembler.accessService
        
        let tabBar = storyAssembler.makeTabBar()
        let navigationViewController = UINavigationController(rootViewController: tabBar)
        window?.rootViewController = navigationViewController
        
        if credentialsService.sessionExists() {
            let navigationViewController = UINavigationController(rootViewController: storyAssembler.makeTabBar())
            window?.rootViewController = navigationViewController
        } else {
            let navigationViewController = UINavigationController(rootViewController: storyAssembler.makeAuthStory())
            window?.rootViewController = navigationViewController
        }
        
        window?.makeKeyAndVisible()
        return true
    }

}
