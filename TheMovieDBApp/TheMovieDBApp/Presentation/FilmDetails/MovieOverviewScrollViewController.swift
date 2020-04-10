//
//  MovieOverviewScrollViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 01.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

final class MovieOverviewScrollViewController: UIViewController {
        
    // MARK: - Private Properties
    
    private var overviewDescription: String?
    
    private lazy var textView = UITextView()
    
    // MARK: - Initializers
    
    init(with text: String) {
        self.overviewDescription = text
        super.init(nibName: nil, bundle: nil)
     }
    
     required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
     }
    
    // MARK: - UIViewController(*)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.font = UIFont.systemFont(ofSize: 17.0)
        textView.textColor = ColorName.fontMain
        
        textView.text = overviewDescription
        
        textView.backgroundColor = ColorName.background
        textView.isEditable = false
        
        view.addSubview(textView)
        
        textView.anchor(top: view.topAnchor,
                        left: view.leftAnchor,
                        bottom: view.bottomAnchor,
                        right: view.rightAnchor,
                        paddingLeft: 24,
                        paddingRight: 24)

    }

}
