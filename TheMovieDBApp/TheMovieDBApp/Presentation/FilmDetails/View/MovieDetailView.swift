//
//  MovieDetailView.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 01.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import UIKit

/// Экран подробной информации о фильме
final class MovieDetails: XibView {
    
    // MARK: - IBOutlet
    @IBOutlet private var posterImage: UIImageView!
    @IBOutlet private var movieNameLabel: UILabel!
    @IBOutlet private var movieOriginalNameLabel: UILabel!
    @IBOutlet private var movieGanreLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var popularityLabel: UILabel!
    @IBOutlet private var voteLabel: UILabel!
    
    // MARK: - Public Properties
    
    var poster: UIImage? {
        set { posterImage.image = newValue }
        get { posterImage.image }
    }
    
    var movieName: String? {
        set { movieNameLabel.text = newValue ?? "" }
        get { movieNameLabel.text ?? "" }
    }
    
    var movieGenre: String? {
        set { movieGanreLabel.text = newValue ?? "" }
        get { movieGanreLabel.text ?? "" }
    }
    
    var movieOriginalName: String? {
        set { movieOriginalNameLabel.text = newValue ?? "" }
        get { movieOriginalNameLabel.text ?? "" }
    }
    
    var popularity: String? {
        set { popularityLabel.text = newValue ?? "" }
        get { popularityLabel.text ?? "" }
    }
    
    var vote: String? {
        set { voteLabel.text = newValue ?? "" }
        get { voteLabel.text ?? "" }
    }
    
    // MARK: - Initializers
        
    init() {
        super.init(frame: .zero)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
