//
//  ZeroSearchViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 01.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

final class ZeroSearchViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var errorLabel = UILabel()
    private lazy var errorImageView = UIImageView(image: ImageName.noMoviesError)
        
    // MARK: - UIViewController(*)

    override func viewDidLoad() {
        super.viewDidLoad()

        errorLabel.text = NSLocalizedString("Nothing found for your request", comment: "")
        errorLabel.textColor = ColorName.fontMain
        errorLabel.numberOfLines = 2

        errorImageView = UIImageView(image: ImageName.noMoviesError)
        
        view.addSubview(errorLabel)
        view.addSubview(errorImageView)
        
        setConstraints()
    }
    
    // MARK: - Private Methods
    
    private func setConstraints() {
        errorLabel.anchor(top: view.topAnchor, left: view.leftAnchor,
                          bottom: nil, right: nil, paddingTop: 45, paddingLeft: 24, paddingBottom: 0,
                          paddingRight: 0, width: 0, height: 0)
        
        errorImageView.anchor(top: errorLabel.bottomAnchor, left: view.leftAnchor,
                              bottom: nil, right: view.rightAnchor, paddingTop: 45, paddingLeft: 64,
                              paddingBottom: 0, paddingRight: 64, width: 0, height: 215)
    }

}
