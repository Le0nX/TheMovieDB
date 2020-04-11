//
//  MoviesCell.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 18.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

/// Ячейка фильма
final class MoviesCell: UITableViewCell {
    
    // MARK: - Constants
    static let cellHight = CGFloat(100)
    
    // MARK: - IBOutlet
    
    @IBOutlet private var posterImage: UIImageView!
    @IBOutlet private var movieName: UILabel!
    @IBOutlet private var movieOriginalName: UILabel!
    @IBOutlet private var ganreLabel: UILabel!
    @IBOutlet private var popularityLabel: UILabel!
    @IBOutlet private var voteCountLabel: UILabel!
    
    // MARK: - Public Properties
    
    var movieNameLabel: String {
        set { movieName.text = newValue }
        get { movieName.text ?? "" }
    }
    
    var poster: UIImage? {
        set { posterImage.image = newValue }
        get { posterImage.image }
    }
    
    var movieOriginalNameLabel: String {
        set { movieOriginalName.text = newValue }
        get { movieOriginalName.text ?? "" }
    }
    
    var popularity: String {
        set { popularityLabel.text = newValue }
        get { popularityLabel.text ?? "" }
    }
    
    var genre: String {
        set { ganreLabel.text = newValue }
        get { ganreLabel.text ?? "" }
    }
    
    var vote: String {
        set { voteCountLabel.text = newValue }
        get { voteCountLabel.text ?? "" }
    }
    
    var movieId = 0
    
    var onReuse: () -> Void = {}
    
    // MARK: - UIViewController(*)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = ColorName.background
        self.imageView?.frame = CGRect(x: 0, y: 0, width: 64, height: 96)
        self.posterImage?.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onReuse()
        posterImage.image = ImageName.filmIconSelected
    }
}
