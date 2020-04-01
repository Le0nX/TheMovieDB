//
//  MovieDetailsViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 01.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

final class MovieDetailsViewController: UIViewController {

    // MARK: - Private Properties
    
    private let containerView: MovieDetails
    private let data: MoviesCell
    
    // MARK: - Initializers
    
    init(_ view: MovieDetails = MovieDetails(), with data: MoviesCell) {
        self.containerView = view
        self.data = data
        super.init(nibName: nil, bundle: nil)
     }
    
     required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
     }
    
    // MARK: - UIViewController(*)
    
    override func loadView() {
        super.loadView()
        self.view = self.containerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Private Methods
    
    private func setup() {
        self.containerView.movieNameLabel.text = data.movieName.text
        self.containerView.movieGanreLabel.text = data.ganreLabel.text
        self.containerView.movieOriginalNameLabel.text = data.movieOriginalName.text
        self.containerView.popularityLabel.text = data.popularityLabel.text
        self.containerView.voteLabel.text = data.voteCountLabel.text
        self.containerView.posterImage.image = data.posterImage.image
    }

}
