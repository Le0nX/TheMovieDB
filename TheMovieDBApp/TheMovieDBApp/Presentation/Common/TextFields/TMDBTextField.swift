//
//  TMDBTextField.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 06.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

final class TMDBTextField: UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderColor = ColorName.borderUnactive.cgColor
        self.layer.borderWidth = CGFloat(1.0)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
}
