//
//  TMBDSearchTextField.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 07.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

/// Класс кастомного поля поиска
final class TMDBSearchTextField: UITextField {
    
    // MARK: - Private Properties
    
    private var iconClick = false
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        setup()
    }
    
    // MARK: - UIViewController(*)
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(x: 10, y: 0, width: 30, height: bounds.height)
    }
    
    // MARK: - Public methods
    
    public func setup() {
        setupPlaceholderColor()
        setupImage()
    }
        
    // MARK: - Private Methods

    private func setupPlaceholderColor() {
        let iVar = class_getInstanceVariable(UITextField.self, "_placeholderLabel")!
        let placeholderLabel = object_getIvar(self, iVar) as? UILabel
        placeholderLabel?.textColor = ColorName.fontMain
    }
    
    private func setupImage() {
        leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: .zero)
        imageView.image = ImageName.searchLoup
        
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        leftView = imageView
    }
}
