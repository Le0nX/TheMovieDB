//
//  KeyBoardButton.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 07.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

final class KeyboardButton: UIButton {
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    // MARK: - Public Methods

    func setupButton() {
        setTitleColor(ColorName.fontMain, for: .normal)
        backgroundColor = ColorName.background
        titleLabel?.font = UIFont.systemFont(ofSize: 32.0)
    }

}
