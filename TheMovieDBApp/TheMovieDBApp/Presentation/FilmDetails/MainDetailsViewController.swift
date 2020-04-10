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
    
    /// Метод проверки текущего фильма на принадлежность к фаворитам
    /// - Parameters:
    ///   - movieId: id фильма
    ///   - complition: хендлер установки цвета кнопки
    func checkIfFavorite(movieId: Int, complition: @escaping(Result<Bool, Error>) -> Void)
}

final class MainDetailsViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var delegate: MainDetailsViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private let movieDetailsViewController: MovieDetailsViewController
    private let movieOverviewController: MovieOverviewScrollViewController
    
    private let movieId: Int
    private var isFavorite: Bool?
        
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
        
        checkFavoriteStatus(movieId: movieId)
    }
    
    // MARK: - Private Methods
    
    private func addDetailsVC() {
        add(movieDetailsViewController)
        movieDetailsViewController.view.anchor(top: view.topAnchor,
                                               left: view.leftAnchor,
                                               right: view.rightAnchor,
                                               height: 190)
    }
    
    private func addOverviewVC() {
        add(movieOverviewController)
        movieOverviewController.view.anchor(top: movieDetailsViewController.view.bottomAnchor,
                                            left: view.leftAnchor,
                                            bottom: view.bottomAnchor,
                                            right: view.rightAnchor,
                                            paddingTop: 5)
    }
    
    private func showError(error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
    
    private func checkFavoriteStatus(movieId: Int) {
        delegate?.checkIfFavorite(movieId: movieId) { [weak self] result in
            switch result {
            case .success(let status):
                if status {
                    self?.animateButton(with: ColorName.link)
                    self?.isFavorite = status
                } else {
                    self?.navigationItem.rightBarButtonItem?.customView?.tintColor = ColorName.fontMain
                    self?.isFavorite = status
                }
            case .failure(let error):
                self?.showError(error: error)
            }
            
        }
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
        guard let isFavorite = isFavorite else { return }
        
        if isFavorite {
            animateButton(with: ColorName.fontMain)
            delegate?.unmarkFavorite(movieId: movieId)
        } else {
            animateButton(with: ColorName.link)
            delegate?.markFavorite(movieId: movieId)
        }
        self.isFavorite = !isFavorite
    }
    
    private func animateButton(with color: UIColor) {
        navigationItem.rightBarButtonItem?.customView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: {
                        self.navigationItem.rightBarButtonItem?.customView?.tintColor = color
                        self.navigationItem.rightBarButtonItem?.customView?.transform = .identity
                        },
                       completion: nil)
    }

}
