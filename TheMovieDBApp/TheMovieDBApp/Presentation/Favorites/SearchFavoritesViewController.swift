//
//  SearchFavoritesViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 02.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import UIKit

final class SearchFavoritesViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var favoriteLabel = UILabel()
        
    // MARK: - UIViewController(*)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorName.background
        
        favoriteLabel.text = NSLocalizedString("Favorites", comment: "")
        favoriteLabel.font = UIFont.systemFont(ofSize: 32.0)
        favoriteLabel.textColor = ColorName.fontMain
        
        view.addSubview(favoriteLabel)
        
        setConstraints()
    }
    
    // MARK: - Private Methods
    
    private func setConstraints() {
        favoriteLabel.anchor(top: view.topAnchor, left: view.leftAnchor,
                             bottom: nil, right: nil, paddingTop: 45, paddingLeft: 24, paddingBottom: 0,
                             paddingRight: 0, width: 0, height: 0)
    }

}
