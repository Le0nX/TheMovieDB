//
//  TMDBButton.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 07.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

final class TMDBButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.isEnabled = false
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
    
    override var isEnabled: Bool {
           didSet {
            if isEnabled {
                backgroundColor = ColorName.buttonActive
                setTitleColor(.white, for: .normal)
            } else {
                backgroundColor = ColorName.buttonUnactive
                setTitleColor(ColorName.buttonUnactiveText, for: .normal)
            }
           }
       }
}
