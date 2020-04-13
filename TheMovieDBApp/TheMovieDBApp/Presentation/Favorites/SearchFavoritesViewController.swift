//
//  SearchFavoritesViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 02.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import UIKit

protocol SearchFavoritesViewControllerDelegate: class {
    /// Метод добавления item'ов в navbar
    func setNavigationItems()
    
    /// Метод удалениия иконки поиска из navbar
    func removerSearchNavigationItem()
}

/// ViewController поиска по избранному
final class SearchFavoritesViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var delegate: SearchFavoritesViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private lazy var favoriteLabel = UILabel()
    private lazy var searchBar = UISearchBar()
        
    // MARK: - UIViewController(*)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorName.background
        
        favoriteLabel.text = NSLocalizedString("Favorites", comment: "")
        favoriteLabel.font = UIFont.systemFont(ofSize: 32.0)
        favoriteLabel.textColor = ColorName.fontMain
        
        view.addSubview(favoriteLabel)
        
        setConstraints()
//        setupSearchBar()
    }
    
    // MARK: - Public Methods
    
    func addSearchBar(_ parentViewController: UIViewController) {

        UIView.animate(withDuration: 0.5) {
            self.delegate?.removerSearchNavigationItem()
            parentViewController.navigationItem.titleView = self.searchBar
            self.setupSearchBar()
        }
    }
    
    // MARK: - Private Methods
    
    private func setupSearchBar() {
        searchBar.showsCancelButton = false
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = ColorName.buttonUnactive
    }
    
    private func setSearchBarConstraints() {
        searchBar.anchor(top: view.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingLeft: 15,
                         paddingRight: 15)
    }
    
    private func setConstraints() {
        favoriteLabel.anchor(top: view.topAnchor,
                             left: view.leftAnchor,
                             paddingTop: 45,
                             paddingLeft: 24)
    }

}
