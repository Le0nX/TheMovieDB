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
    
    private lazy var label = UILabel()
    private lazy var profileImage = UIImageView()
    
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
    
    /// Метод установки текущего заголовка
    /// - Parameter text: заголовок
    func set(text: String) {
        profileImage.isHidden = true
        label.text = text
        label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    /// Метод установки профиля
    /// - Parameter profile: профиль
    func set(profile: Profile) {
        label.topAnchor.constraint(equalTo: profileImage.bottomAnchor).isActive = true
        label.text = profile.name
        if let data = profile.image {
            profileImage.image = UIImage(data: data)!
        }
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 32.0)
        label.textColor = ColorName.fontMain
        
        view.addSubview(profileImage)
        profileImage.anchor(top: view.topAnchor,
                            width: 70,
                            height: 70)
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(label)
        label.anchor(top: profileImage.bottomAnchor,
                     left: view.leftAnchor,
                     bottom: view.bottomAnchor,
                     right: view.rightAnchor,
                     paddingLeft: 24,
                     paddingBottom: 25,
                     paddingRight: 24)
    }
}
