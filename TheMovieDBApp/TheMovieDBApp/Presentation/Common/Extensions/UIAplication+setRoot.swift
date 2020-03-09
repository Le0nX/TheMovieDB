//
//  UIAplication+setRoot.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

extension UIApplication {
    public static func setRootView(_ viewController: UIViewController) {
        
        let snapshot = (UIApplication.shared.keyWindow?.snapshotView(afterScreenUpdates: true))!
        viewController.view.addSubview(snapshot)
        
        // A mask of options indicating how you want to perform the animations.
        let options: UIView.AnimationOptions = .transitionCrossDissolve

        // The duration of the transition animation, measured in seconds.
        let duration: TimeInterval = 0.3

        // Creates a transition animation.
        // Though `animations` is optional, the documentation tells us that it must not be nil. ¯\_(ツ)_/¯
        UIView.transition(with: UIApplication.shared.keyWindow!,
                          duration: duration,
                          options: options,
                          animations: { snapshot.layer.opacity = 0 },
                          completion: { _ in
                                UIApplication.shared.keyWindow?.rootViewController = viewController
        })
    }
}
