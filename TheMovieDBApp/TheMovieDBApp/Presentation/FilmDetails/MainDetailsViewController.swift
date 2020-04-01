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
        
    // MARK: - Initializers
    
    init(movieDetailsViewController: MovieDetailsViewController,
         movieOverviewController: MovieOverviewScrollViewController) {
                
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
        self.view.backgroundColor = ColorName.background
        
        addDetailsVC()
        addOverviewVC()
    }
    
    // MARK: - Public methods
    
    // MARK: - IBAction
    
    // MARK: - Private Methods
    
    private func addDetailsVC() {
        add(movieDetailsViewController)
        movieDetailsViewController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil,
                                               right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0,
                                               paddingRight: 0, width: 0, height: 190)
    }
    
    private func addOverviewVC() {
        add(movieOverviewController)
        movieOverviewController.view.anchor(top: movieDetailsViewController.view.bottomAnchor,
                                            left: view.leftAnchor, bottom: view.bottomAnchor,
                                            right: view.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0,
                                            paddingRight: 0, width: 0, height: 0)
    }

}
