//
//  UIViewController+child.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 31.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Добалвение нового child view contoller'a
    /// - Parameter child: view controller, который неоходимо добавить
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    /// удаление child view controller из родителя
    func remove() {
        /// в рамках безопасности проверяем, что данный
        /// чайлд вообще был добавлен
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
