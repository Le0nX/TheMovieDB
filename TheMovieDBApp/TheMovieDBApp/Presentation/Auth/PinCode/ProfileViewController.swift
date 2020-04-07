//
//  ProfileViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 07.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

/// Класс для отображения шапки профиля на экране пинкода
final class ProfileViewController: UIViewController {
    
    // MARK: - UIViewController(*)
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        
        setup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "Придумайте пин-код\nдля быстрого входа"
        label.font = UIFont.systemFont(ofSize: 32.0)
        label.textColor = ColorName.fontMain
        
        view.addSubview(label)
        label.anchor(top: view.topAnchor,
                     left: view.leftAnchor,
                     bottom: view.bottomAnchor,
                     right: view.rightAnchor,
                     paddingTop: 0,
                     paddingLeft: 24,
                     paddingBottom: 25,
                     paddingRight: 24,
                     width: 0,
                     height: 0)
    }
}
