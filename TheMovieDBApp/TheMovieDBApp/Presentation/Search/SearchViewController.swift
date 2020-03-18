//
//  SearchViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 07.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

protocol SearchViewInput {
    
    /// Метод закладки данных в таблицу фильмов
    /// - Parameter movies: DTO фильмов
    func setMoviesData(movies: [MovieEntity])
    
    /// Метод показа спиннера
    func showProgress()
    
    /// Метод скрытия спиннера
    func hideProgress()
}

final class SearchViewController: UIViewController {
    
    // MARK: - Public Properties
    
    public var output: SearchPresenterOutput?
    
    // MARK: - Private Properties
    
    private let containerView: SearchView
    private var isSearching = false
    
    private var moviesData = [MovieEntity]()
    
    // MARK: - Initializers
    
    init(_ view: SearchView = SearchView()) {
         self.containerView = view
         super.init(nibName: nil, bundle: nil)
     }
    
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    // MARK: - UIViewController(*)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containerView.searchTextField.addTarget(self,
                                                action: #selector(textFieldEditingDidChange(textField:)),
                                                for: .editingChanged)
        containerView.searchTextField.addTarget(self,
                                                action: #selector(textFieldShouldClear(textField:)),
                                                for: .editingDidEnd)
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.containerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        
        self.containerView.tableView.delegate = self
        self.containerView.tableView.dataSource = self
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Public Mehtods
    
    @objc
    func textFieldEditingDidChange(textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            return
        }
        output?.didEnteredMovie(name: text)
        
        if isSearching { return }
        
        isSearching = true
        UIView.animate(withDuration: 0.5) {
            self.containerView.headerLabel.alpha = 0
            self.containerView.imageView.alpha = 0
            self.containerView.topConstraint.constant -= 150
            self.containerView.tableView.alpha = 1
            self.containerView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    func textFieldShouldClear(textField: UITextField) {
        if !isSearching { return }
        
        isSearching = false
        UIView.animate(withDuration: 0.5) {
            self.containerView.headerLabel.alpha = 1
            self.containerView.imageView.alpha = 1
            self.containerView.topConstraint.constant += 150
            self.containerView.tableView.alpha = 0
            self.containerView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
}

extension SearchViewController: SearchViewInput {
    
    func setMoviesData(movies: [MovieEntity]) {
        self.moviesData = movies
        self.containerView.tableView.reloadData()
    }
    
    func showProgress() {
        self.showSpinner(onView: self.view)
    }
    
    func hideProgress() {
        self.removeSpinner()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moviesData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesCell") as? MoviesCell else {
            return UITableViewCell()
        }
        cell.movieName.text = moviesData[indexPath.row].title
        cell.movieOriginalName.text = moviesData[indexPath.row].originalTitle
        cell.popularityLabel.text = String(moviesData[indexPath.row].popularity ?? 0)
        if let poster = moviesData[indexPath.row].image {
            output?.fetchImage(for: poster) { data in
                if let data = data {
                    cell.posterImage.image = UIImage(data: data)
                } else {
                    cell.posterImage.image = ImageName.filmIconSelected
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
