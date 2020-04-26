//
//  KeyBoardButton.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 07.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

/// Класс кастомной кнопки клавиатуры PinCode
final class KeyboardButton: UIButton {
    
    // MARK: - Public Properties
    
    override var isHighlighted: Bool {
        didSet {
            self.titleLabel?.alpha = 1
            if isHighlighted {
                UIView.animate(withDuration: 0.1) {
                    self.backgroundColor = ColorName.buttonActive
                }
            } else {
                UIView.animate(withDuration: 0.1) {
                    self.backgroundColor = ColorName.background
                }
            }
        }
    }
    
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
    
    func pressButton() {
        isHighlighted = !isHighlighted
    }
    
    // MARK: - Private Methods

    private func setupButton() {
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
        setTitleColor(ColorName.fontMain, for: .normal)
        backgroundColor = ColorName.background
        titleLabel?.font = UIFont.systemFont(ofSize: 32.0)
    }

}
