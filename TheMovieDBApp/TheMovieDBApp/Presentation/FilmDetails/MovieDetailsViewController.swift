//
//  MovieDetailsViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 01.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
    
    // MARK: - Types
    
    // MARK: - Constants
    
    // MARK: - IBOutlet
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private let containerView: MovieDetails
    
    // MARK: - Initializers
    
    init(_ view: MovieDetails = MovieDetails()) {
         self.containerView = view
         super.init(nibName: nil, bundle: nil)
     }
    
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    // MARK: - UIViewController(*)
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Public methods
    
    // MARK: - IBAction
    
    // MARK: - Private Methods

}
