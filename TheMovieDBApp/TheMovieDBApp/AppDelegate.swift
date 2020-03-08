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
        UINavigationBar.appearance().barTintColor = ColorName.background
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage() // убарна линия сепаратора
        
        UITabBar.appearance().barTintColor = #colorLiteral(red: 0.1568627451, green: 0.1725490196, blue: 0.2470588235, alpha: 1)
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().selectedImageTintColor = ColorName.buttonActive

        let navigationViewController = UINavigationController(rootViewController: LoginViewController())
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
        return true
    }

}
