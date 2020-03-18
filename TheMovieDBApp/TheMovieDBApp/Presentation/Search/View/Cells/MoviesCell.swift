//
//  MoviesCell.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 18.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

class MoviesCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieOriginalName: UILabel!
    @IBOutlet weak var ganreLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    
    // MARK: - UIViewController(*)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = ColorName.background
        self.imageView?.frame = CGRect(x: 0, y: 0, width: 64, height: 96)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
