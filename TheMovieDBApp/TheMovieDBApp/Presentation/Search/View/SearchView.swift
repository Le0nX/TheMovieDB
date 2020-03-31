//
//  SearchView1.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 07.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

final class SearchView: XibView {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var searchTextField: TMDBSearchTextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    lazy var errorLabel = UILabel()
    lazy var errorImageView = UIImageView(image: ImageName.noMoviesError)
    
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
        
        errorLabel.text = NSLocalizedString("Nothing found for your request", comment: "")
        errorLabel.textColor = ColorName.fontMain
        errorLabel.numberOfLines = 2

        errorImageView = UIImageView(image: ImageName.noMoviesError)
    }
}
