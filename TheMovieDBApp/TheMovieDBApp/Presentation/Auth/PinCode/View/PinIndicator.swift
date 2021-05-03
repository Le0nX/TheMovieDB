//
//  PinIndicator.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 08.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

/// Индикатор заполнения пинкода
final class PinIndicator: UIView {

    // MARK: - UIViewController(*)
    
    override func layoutSubviews() {
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
    }
    
    // MARK: - Public Methods
    
    /// Пометить индикатор красным
    public func makeRed() {
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = .red
        }
    }
    
    /// Метод заполнения одного индикатора
    public func animateFilling() {
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = ColorName.buttonActive
        }
    }
    
    /// Метод сброса  индикатора
    public func animateResetFilling() {
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = ColorName.borderUnactive
        }
    }
}
