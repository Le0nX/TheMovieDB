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

final class MainSearchViewController: UIViewController {
    
    // MARK: - Public Properties
    
    public var output: SearchPresenterOutput?
    
    // MARK: - Private Properties
    
    private let searchViewController = SearchViewController()
    private let searchTableViewController = SearchTableViewController()
    private let searchEmptyResultController = ZeroSearchViewController()
    
    // MARK: - UIViewController(*)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableViewController.delegate = self
        searchViewController.delegate = self
        
        addSearchVC()
    }
    
    // MARK: - Private Methods
    
    private func addSearchVC() {
        
        add(searchViewController)
        searchViewController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,
                                         right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0,
                                         paddingRight: 0, width: 0, height: 0)
    }
    
    private func addSearchTableVC() {
        add(searchTableViewController)
        
        searchTableViewController.tableView.anchor(top: view.topAnchor, left: view.leftAnchor,
                                                   bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 85,
                                                   paddingLeft: 24, paddingBottom: 0, paddingRight: 24,
                                                   width: 0, height: 0)
    }
    
    private func addEmptyResultVC() {
        add(searchEmptyResultController)
        
        searchEmptyResultController.view.anchor(top: view.topAnchor, left: view.leftAnchor,
                                                bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 55,
                                                paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                                                width: 0, height: 0)
    }
}

extension MainSearchViewController: SearchViewInput {
    
    func setMoviesData(movies: [MovieEntity]) {
        if movies.isEmpty {
            searchTableViewController.remove()
            addEmptyResultVC()
        } else {
            addSearchTableVC()
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
    
    func textFieldEditingDidChange(with name: String) {
        output?.didEnteredMovie(name: name)
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
        self.navigationController?.pushViewController(MainDetailsViewController(with: model), animated: true)
    }
    
    func fetchImage(for poster: String, completion: @escaping (Data?) -> Void) -> UUID? {
        output?.fetchImage(for: poster, completion: completion)
    }
    
    func cancelTask(for poster: UUID) {
        output?.cancelTask(for: poster)
    }
    
}
