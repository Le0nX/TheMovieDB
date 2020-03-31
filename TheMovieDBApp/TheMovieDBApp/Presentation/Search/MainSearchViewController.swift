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
    
    private let searchViewController: SearchViewController
    private let searchTableViewController: SearchTableViewController
    
    // MARK: - Initializers
    
    init(searchViewController: SearchViewController = SearchViewController(),
         searchTableViewController: SearchTableViewController = SearchTableViewController()) {
        
        self.searchViewController = searchViewController
        self.searchTableViewController = searchTableViewController
        
        super.init(nibName: nil, bundle: nil)
     }
    
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
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
        
        searchTableViewController.tableView.alpha = 1
        searchTableViewController.tableView.anchor(top: view.topAnchor, left: view.leftAnchor,
                                                   bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 85,
                                                   paddingLeft: 24, paddingBottom: 0, paddingRight: 24,
                                                   width: 0, height: 0)
    }
}

extension MainSearchViewController: SearchViewInput {
    
    func setMoviesData(movies: [MovieEntity]) {
        if movies.isEmpty {
            searchTableViewController.remove()
            searchViewController.showNoResultsError()
        } else {
            addSearchTableVC()
            searchViewController.hideNoResultsError()
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
    
    func hideTableView() {
        searchViewController.hideNoResultsError()
        searchTableViewController.tableView.alpha = 0
    }
    
}

extension MainSearchViewController: SearchTableViewControllerDelegate {
    
    func fetchImage(for poster: String, completion: @escaping (Data?) -> Void) -> UUID? {
        output?.fetchImage(for: poster, completion: completion)
    }
    
    func cancelTask(for poster: UUID) {
        output?.cancelTask(for: poster)
    }
    
}