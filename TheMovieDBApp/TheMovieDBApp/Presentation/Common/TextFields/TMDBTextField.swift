//
//  TMDBTextField.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 06.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

/// Класс кастомного поля
final class TMDBTextField: UITextField {
    
    // MARK: - Private Properties
    
    private var iconClick = false
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderColor = ColorName.borderUnactive.cgColor
        self.layer.borderWidth = CGFloat(1.0)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                   attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3960784314, green: 0.4274509804, blue: 0.5411764706, alpha: 1)])
    }
    
    // MARK: - UIViewController(*)
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(x: bounds.width - 40, y: 0, width: 30, height: bounds.height)
    }
    
    // MARK: - Public methods
    
    /// Метод настройки расположения иконки
    func setupImage() {
        rightViewMode = UITextField.ViewMode.always
        let btn = UIButton(frame: .zero)
        btn.addTarget(self, action: #selector(iconAction), for: .touchUpInside)
        btn.imageView?.adjustsImageSizeForAccessibilityContentSizeCategory = true
        btn.imageView?.contentMode = UIView.ContentMode.scaleAspectFit

        btn.setImage(ImageName.loginEye, for: .normal)
        rightView = btn
    }
    
    @objc func iconAction(sender: UIButton) {
        if iconClick {
            self.isSecureTextEntry = true
            sender.setImage(ImageName.loginEye, for: .normal)
        } else {
            self.isSecureTextEntry = false
            sender.setImage(ImageName.loginEyeOff, for: .normal)
        }

        iconClick = !iconClick
    }
}
