//
//  AppDelegate.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 06.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import TMDBNetwork
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var isUnitTesting: Bool {
      // ускоритель юнит-тестов
      ProcessInfo.processInfo.arguments.contains("-UNITTEST")
    }
    
    func isDebuggerAttached() -> Bool {
        getppid() != 1
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        #if RELEASE
        if isDebuggerAttached() {
            fatalError()
        }
        #endif
        
        if JaibreakDetector.jailbroken() {
            fatalError()
        }
        
        if !isUnitTesting {
            
            window = UIWindow(frame: UIScreen.main.bounds)
            
            ApplicationAppearance.setupNavigatioBar()
            ApplicationAppearance.setupTabBar()
            
            let serviceAssembler = ServiceFabric()
            let storyAssembler = StoryFabric(servicesAssembler: serviceAssembler)
            
            let credentialsService = serviceAssembler.accessService
            
            if credentialsService.sessionIsValid() ||
                (credentialsService.credentials != nil && !NetworkReachability().isNetworkAvailable()) {
                
                window?.rootViewController = storyAssembler.makePinCodeStory(with: .lock(image: ImageName.faceId))
            } else {
                let navigationViewController = UINavigationController(
                                                                     rootViewController: storyAssembler.makeAuthStory())
                window?.rootViewController = navigationViewController
            }
            
            window?.makeKeyAndVisible()
            
        }
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        self.window?.viewWithTag(99999)?.removeFromSuperview()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = window!.frame
        blurEffectView.tag = 99999

        self.window?.addSubview(blurEffectView)
    }

}
