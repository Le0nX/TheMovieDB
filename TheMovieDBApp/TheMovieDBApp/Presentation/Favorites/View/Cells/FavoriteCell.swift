//
//  FavoriteCell.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 02.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

final class FavoriteCell: UICollectionViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieOriginalName: UILabel!
    @IBOutlet weak var ganreLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    
    // MARK: - Public Properties
    
    var onReuse: () -> Void = {}
        
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UIViewController
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = ColorName.background
        self.posterImage?.layer.cornerRadius = 8
    }

}
