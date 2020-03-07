//
//  TMDBTextField.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 06.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

final class TMDBTextField: UITextField {
    private var iconClick = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderColor = ColorName.borderUnactive.cgColor
        self.layer.borderWidth = CGFloat(1.0)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        setupPlaceholderColor()
    }
    
    private func setupPlaceholderColor() {
        let iVar = class_getInstanceVariable(UITextField.self, "_placeholderLabel")!
        let placeholderLabel = object_getIvar(self, iVar) as? UILabel
        placeholderLabel?.textColor = #colorLiteral(red: 0.3960784314, green: 0.4274509804, blue: 0.5411764706, alpha: 1)
    }
    
    func setupImage() {
        rightViewMode = UITextField.ViewMode.always
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        btn.addTarget(self, action: #selector(iconAction), for: .touchUpInside)
        btn.imageView?.adjustsImageSizeForAccessibilityContentSizeCategory = true
        btn.imageView?.contentMode = UIView.ContentMode.scaleAspectFit

        btn.setImage(ImageName.loginEye, for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        rightView = btn
    }
    
    @objc func iconAction(sender: UIButton) {
        if iconClick  {
            self.isSecureTextEntry = true
            sender.setImage(ImageName.loginEye, for: .normal)
        } else {
            self.isSecureTextEntry = false
            sender.setImage(ImageName.loginEyeOff, for: .normal)
        }

        iconClick = !iconClick
    }
}
