//
//  ProfileViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 07.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

/// Класс для отображения шапки профиля на экране пинкода (будет реализован в будущем)
final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var label = UILabel()
    
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
    
    // MARK: - Public Methods
    
    func set(profile: String) {
        // TODO: - замени на бизнес модель
        label.text = profile
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Придумайте пин-код\nдля быстрого входа"
        label.font = UIFont.systemFont(ofSize: 32.0)
        label.textColor = ColorName.fontMain
        
        view.addSubview(label)
        label.anchor(top: view.topAnchor,
                     left: view.leftAnchor,
                     bottom: view.bottomAnchor,
                     right: view.rightAnchor,
                     paddingLeft: 24,
                     paddingBottom: 25,
                     paddingRight: 24)
    }
}
