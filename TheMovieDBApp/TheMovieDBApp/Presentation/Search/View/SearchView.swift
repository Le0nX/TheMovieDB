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
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var searchTextField: TMDBSearchTextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
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
}
