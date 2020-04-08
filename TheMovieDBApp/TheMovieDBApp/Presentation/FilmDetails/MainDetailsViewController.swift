//
//  MainDetailsViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 01.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

protocol MainDetailsViewControllerDelegate: class {
    /// Метод создания фаворита
    /// - Parameter movieId: id фильма
    func markFavorite(movieId: Int)
    
    /// Метод удаления фаворита
    /// - Parameter movieId: id фильма
    func unmarkFavorite(movieId: Int)
}

final class MainDetailsViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var delegate: MainDetailsViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private let movieDetailsViewController: MovieDetailsViewController
    private let movieOverviewController: MovieOverviewScrollViewController
    
    private let movieId: Int
        
    // MARK: - Initializers
    
    init(with model: MovieDetail) {
            
        self.movieId = model.movieId
        self.movieDetailsViewController = MovieDetailsViewController(with: model)
        self.movieOverviewController = MovieOverviewScrollViewController(with: model.overview ?? "")
        
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
        
        setBarItem()
        
        addDetailsVC()
        addOverviewVC()
    }
    
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
    
    private func setBarItem() {
        let icon = ImageName.favoriteIcon
        let iconSize = CGRect(origin: .zero, size: icon.size)
        let iconButton = UIButton(frame: iconSize)
        iconButton.addTarget(self, action: #selector(markFavorite), for: .touchUpInside)
        iconButton.setBackgroundImage(icon, for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: iconButton)
    }
    
    @objc private func markFavorite() {
        animateButton()
        delegate?.markFavorite(movieId: movieId)
    }
    
    private func animateButton() {
        navigationItem.rightBarButtonItem?.customView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: {
                        self.navigationItem.rightBarButtonItem?.customView?.transform = .identity
                        },
                       completion: nil)
    }

}
