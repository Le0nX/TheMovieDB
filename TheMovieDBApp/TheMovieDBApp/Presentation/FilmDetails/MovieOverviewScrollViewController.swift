//
//  MovieOverviewScrollViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 01.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

final class MovieOverviewScrollViewController: UIViewController {

    // MARK: - Types
    
    // MARK: - Constants
    
    // MARK: - IBOutlet
    
    // MARK: - Public Properties
        
    // MARK: - Private Properties
    
    private var overviewDescription: String?
    
    private lazy var scrollView = UITextView()
    
    // MARK: - Initializers
    
    // MARK: - UIViewController(*)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.text = overviewDescription
        scrollView.backgroundColor = ColorName.background
        scrollView.isEditable = false
        
        view.addSubview(scrollView)
        
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,
                          right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0,
                          paddingRight: 0, width: 0, height: 0)

    }
    
    // MARK: - Public methods

    // MARK: - IBAction
    
    // MARK: - Private Methods

}
