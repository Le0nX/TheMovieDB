//
//  PinCodeView.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 07.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

protocol PinCodeViewDelegate: class {
    
    /// Выход с экрана пинкода
    func exit()
    
    /// выбор входа  по Face ID
    func didSelectedFaceId()
    
    /// Метод показа ошибки
    /// - Parameter message: текст ошибки
    func showErrorMessage(_ message: String)
}

final class PinCodeView: XibView {

    // MARK: - IBOutlet
    @IBOutlet var numPudButtons: [KeyboardButton]!
    
    // MARK: - Public Properties
    
    weak var delegate: PinCodeViewDelegate!
        
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = ColorName.background
    }
}
