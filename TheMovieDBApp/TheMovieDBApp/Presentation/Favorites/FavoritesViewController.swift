//
//  FavoritesViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 07.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

final class FavoritesViewController: UIViewController {
    private let containerView: FavoritesView
       
    init(_ view: FavoritesView = FavoritesView()) {
        self.containerView = view
        super.init(nibName: nil, bundle: nil)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func loadView() {
        super.loadView()
        self.view = self.containerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true

        self.hideKeyboardWhenTappedAround()
    }
}
