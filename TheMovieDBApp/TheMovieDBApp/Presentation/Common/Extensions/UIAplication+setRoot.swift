//
//  UIAplication+setRoot.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

extension UIApplication {
    
    /// Метод выставления рутового экрана
    /// - Parameter viewController: viewcontroller, который будет сделан рутовым
    public static func setRootView(_ viewController: UIViewController) {
        
        guard let root = UIApplication.shared.keyWindow else {
            return
        }
        
        let snapshot = (root.snapshotView(afterScreenUpdates: true))!
        viewController.view.addSubview(snapshot)
        
        /// маска анимаций
        let options: UIView.AnimationOptions = .transitionCrossDissolve

        /// продолжительность анимации
        let duration: TimeInterval = 0.6

        /// создает транизитную анимацию
        UIView.transition(with: root,
                          duration: duration,
                          options: options,
                          animations: { snapshot.layer.opacity = 0 },
                          completion: { _ in
                                root.rootViewController = viewController
        })
    }
}
