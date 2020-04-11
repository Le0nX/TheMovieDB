//
//  MainSearchViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 31.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import UIKit

protocol SearchViewInput {
    
    /// Метод закладки данных в таблицу фильмов
    /// - Parameter movies: DTO фильмов
    func setMoviesData(movies: [MovieEntity])
    
    /// Метод отображения ошибки поиска
    /// - Parameter error: описание ошибки
    func showError(error: Error)
}

/// Контейнер ViewController для экрана поиска фильмов
final class MainSearchViewController: UIViewController {
    
    // MARK: - Public Properties
    
    public var loader: SearchLoader?

    // MARK: - Private Properties
        
    private let searchTableViewController: SearchTableViewController
    
    private let searchViewController = SearchViewController()
    private let searchEmptyResultController = ZeroSearchViewController()
    
    // MARK: - Initializers
    
    init(imageLoader: ImageLoader) {
        self.searchTableViewController = SearchTableViewController(imageLoader: imageLoader)
        super.init(nibName: nil, bundle: nil)
     }
    
     required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
     }
    
    // MARK: - UIViewController(*)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.view.alpha = 0
        
        searchTableViewController.delegate = self
        searchViewController.delegate = self
        
        addSearchViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.navigationController?.view.alpha = 1
        }, completion: nil)
    }
    
    // MARK: - Private Methods
    
    private func addSearchViewController() {
        
        add(searchViewController)
        searchViewController.view.anchor(top: view.topAnchor,
                                         left: view.leftAnchor,
                                         bottom: view.bottomAnchor,
                                         right: view.rightAnchor)
    }
    
    private func addSearchTableViewController() {
        add(searchTableViewController)
        
        searchTableViewController.tableView.anchor(top: view.topAnchor,
                                                   left: view.leftAnchor,
                                                   bottom: view.bottomAnchor,
                                                   right: view.rightAnchor,
                                                   paddingTop: 85,
                                                   paddingLeft: 24,
                                                   paddingRight: 24)
    }
    
    private func addEmptyResultViewController() {
        add(searchEmptyResultController)
        
        searchEmptyResultController.view.anchor(top: view.topAnchor,
                                                left: view.leftAnchor,
                                                bottom: view.bottomAnchor,
                                                right: view.rightAnchor,
                                                paddingTop: 55)
    }
}

extension MainSearchViewController: SearchViewInput {
    
    func setMoviesData(movies: [MovieEntity]) {
        if movies.isEmpty {
            searchTableViewController.remove()
            addEmptyResultViewController()
        } else {
            addSearchTableViewController()
            searchEmptyResultController.remove()
            searchTableViewController.searhTableViewSetData(movies: movies)
        }
    }
    
    func showError(error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
}

extension MainSearchViewController: SearchViewControllerDelegate {
    
    func searchTextFieldDidChange(with name: String) {
        loader?.didEnteredMovie(name: name)
        UIView.animate(withDuration: 0.5) {
            self.searchTableViewController.tableView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func hideSearchResults() {
        searchEmptyResultController.remove()
        searchTableViewController.tableView.alpha = 0
    }
    
}

extension MainSearchViewController: SearchTableViewControllerDelegate {
    
    func openDetailsViewController(with model: MovieDetail) {
        let vc = MainDetailsViewController(with: model)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MainSearchViewController: MainDetailsViewControllerDelegate {
    func checkIfFavorite(movieId: Int, complition: @escaping (Result<Bool, Error>) -> Void) {
        loader?.checkIfFavorite(movieId: movieId, complition: complition)
    }
    
    func markFavorite(movieId: Int) {
        loader?.markFavorite(movieId: movieId)
    }
    
    func unmarkFavorite(movieId: Int) {
        loader?.unmarkFavorite(movieId: movieId)
    }
}
