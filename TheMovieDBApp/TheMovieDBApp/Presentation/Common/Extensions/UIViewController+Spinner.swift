//
//  UIViewController+Spinner.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 08.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

var vSpinner: UIView?

extension UIViewController {
    
    /// Метод отображения спиннера
    /// - Parameter onView: view, где будет показан спиннер
    func showSpinner(onView: UIView) {
        let spinnerView = UIView(frame: onView.bounds)
        
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    /// Метод сокрытия спиннера
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
