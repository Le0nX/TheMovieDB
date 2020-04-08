//
//  PinIndicator.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 08.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

final class PinIndicator: UIView {

    // MARK: - UIViewController(*)
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
    }
    
    // MARK: - Public Methods
    
    public func animateFilling() {
        UIView.animate(withDuration: 2) {
            self.backgroundColor = ColorName.buttonActive
        }
    }

    
    public func animateResetFilling() {
        UIView.animate(withDuration: 2) {
            self.backgroundColor = ColorName.borderUnactive
        }
    }
}
