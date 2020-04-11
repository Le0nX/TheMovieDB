//
//  SearchView1.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 07.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

/// Экран поиска  с текстфиелдом
final class SearchView: XibView {
    
    // MARK: - IBOutlet
    
    @IBOutlet private var headerLabel: UILabel!
    @IBOutlet public var searchTextField: TMDBSearchTextField!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var topConstraint: NSLayoutConstraint!
    
    // MARK: - Public Properties
    
    var header: String {
        set { headerLabel.text = newValue }
        get { headerLabel.text ?? "" }
    }
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
        
    // MARK: - Public methods
    
    func setup() {
        contentView.backgroundColor = ColorName.background
    }
    
    /// Поднимаем текстфиелд вверх и скрываем все остальное
    func showUP() {
        headerLabel.alpha = 0
        imageView.alpha = 0
        topConstraint.constant -= 150
    }
    
    /// Опускаем текстфиелд вниз и показываем все остальное
    func showDown() {
        headerLabel.alpha = 1
        imageView.alpha = 1
        topConstraint.constant += 150
    }
}
