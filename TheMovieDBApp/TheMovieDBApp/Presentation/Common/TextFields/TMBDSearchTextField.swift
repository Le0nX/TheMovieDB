//
//  TMBDSearchTextField.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 07.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

final class TMDBSearchTextField: UITextField {
    private var iconClick = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        setup()
    }
    
    public func setup() {
        setupPlaceholderColor()
        setupImage()
    }
    
    private func setupPlaceholderColor() {
        let iVar = class_getInstanceVariable(UITextField.self, "_placeholderLabel")!
        let placeholderLabel = object_getIvar(self, iVar) as? UILabel
        placeholderLabel?.textColor = ColorName.fontMain
    }
    
    private func setupImage() {
        leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 15, y: 0, width: 40, height: 25))
        imageView.image = ImageName.searchLoup
        
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        leftView = imageView
    }
}
