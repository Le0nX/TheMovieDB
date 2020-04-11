//
//  MovieDetailsViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 01.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

/// ViewContoller подробной информации о фильме
final class MovieDetailsViewController: UIViewController {

    // MARK: - Private Properties
    
    private let containerView = MovieDetails()
    private let data: MovieDetail
    
    // MARK: - Initializers
    
    init(with data: MovieDetail) {
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
        self.containerView.movieName = data.movieName
        self.containerView.movieGenre = data.genre
        self.containerView.movieOriginalName = data.movieOriginalName
        self.containerView.popularity = data.popularity
        self.containerView.vote = data.votes
        self.containerView.poster = data.poster
    }

}
