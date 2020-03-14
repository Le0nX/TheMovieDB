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
        
        /// маска анимаций
        let options: UIView.AnimationOptions = .transitionCrossDissolve

        /// продолжительность анимации
        let duration: TimeInterval = 0.3

        /// создает транизитную анимацию
        UIView.transition(with: UIApplication.shared.keyWindow!,
                          duration: duration,
                          options: options,
                          animations: { snapshot.layer.opacity = 0 },
                          completion: { _ in
                                UIApplication.shared.keyWindow?.rootViewController = viewController
        })
    }
}
