//
//  MainDetailsViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 01.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

final class MainDetailsViewController: UIViewController {
    // MARK: - Types
    
    // MARK: - Constants
    
    // MARK: - IBOutlet
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private let movieDetailsViewController: MovieDetailsViewController
    private let movieOverviewController: MovieOverviewScrollViewController
    
    private let data: MovieEntity
    
    // MARK: - Initializers
    
    init(with data: MovieEntity,
         movieDetailsViewController: MovieDetailsViewController = MovieDetailsViewController(),
         movieOverviewController: MovieOverviewScrollViewController = MovieOverviewScrollViewController()) {
        
        self.data = data
        
        self.movieDetailsViewController = movieDetailsViewController
        self.movieOverviewController = movieOverviewController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController(*)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = ColorName.fontMain
        self.navigationController?.navigationBar.topItem?.title = ""
        print(data.overview)
    }
    
    // MARK: - Public methods
    
    // MARK: - IBAction
    
    // MARK: - Private Methods

}
