//
//  FavoritesView.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 07.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

/// Экран избранного
final class FavoritesView: XibView {
    @IBOutlet weak var zeroView: ZeroFavoritesView!
    
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
