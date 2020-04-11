//
//  FavoriteCell.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 02.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

/// Ячейка избранного
final class FavoriteCell: UICollectionViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet private var posterImage: UIImageView!
    @IBOutlet private var movieName: UILabel!
    @IBOutlet private var movieOriginalName: UILabel!
    @IBOutlet private var ganreLabel: UILabel!
    @IBOutlet private var popularityLabel: UILabel!
    @IBOutlet private var voteCountLabel: UILabel!
    
    @IBOutlet private var stackView: UIStackView!
    
    // MARK: - Public Properties
        
    var poster: UIImage? {
        set { posterImage.image = newValue }
        get { posterImage.image }
    }
    
    var moviesName: String? {
        set { movieName.text = newValue ?? "" }
        get { movieName.text ?? "" }
    }
    
    var movieGenre: String? {
        set { ganreLabel.text = newValue ?? "" }
        get { ganreLabel.text ?? "" }
    }
    
    var movieOriginalsName: String? {
        set { movieOriginalName.text = newValue ?? "" }
        get { movieOriginalName.text ?? "" }
    }
    
    var popularity: String? {
        set { popularityLabel.text = newValue ?? "" }
        get { popularityLabel.text ?? "" }
    }
    
    var vote: String? {
        set { voteCountLabel.text = newValue ?? "" }
        get { voteCountLabel.text ?? "" }
    }
    
    var onReuse: () -> Void = {}
        
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
       super.layoutSubviews()
       updateContentStyle()
   }
    
    // MARK: - UIViewController
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = ColorName.background
        self.posterImage.clipsToBounds = true
        self.posterImage?.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Private Methods
    
    private func updateContentStyle() {
        let isHorizontalStyle = bounds.width > 2 * bounds.height
        let oldAxis = stackView.axis
        let newAxis: NSLayoutConstraint.Axis = isHorizontalStyle ? .horizontal : .vertical
        guard oldAxis != newAxis else { return }

        stackView.axis = newAxis
        stackView.alignment = isHorizontalStyle ? .center : .leading

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}
