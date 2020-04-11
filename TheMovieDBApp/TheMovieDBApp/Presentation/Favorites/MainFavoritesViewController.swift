//
//  MainFavoritesViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 02.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import UIKit

/// Контейнер-ViewController избранного
final class MainFavoritesViewController: UIViewController {
    
    // MARK: - Type
    
    private enum PresentationStyle: String, CaseIterable {
        case table
        case defaultGrid
        
        var buttonImage: UIImage {
            switch self {
            case .table:
                return ImageName.listIcon
            case .defaultGrid:
                return ImageName.collectionIcon
            }
        }
    }
    
    // MARK: - Public Properties
    
    public var  loader: FavoritesLoader?
    
    // MARK: - Private Properties
    
    private var selectedStyle: PresentationStyle = .table {
        didSet { updatePresentationStyle() }
    }
    
    private var styleDelegates: [PresentationStyle: UICollectionViewDelegateFlowLayout] = {
        let result: [PresentationStyle: UICollectionViewDelegateFlowLayout] = [
            .table: TableContentLayoutFlowDelegate(),
            .defaultGrid: CollectionContentLayoutFlowDelegate()
        ]
        return result
    }()
    
    private let favoritesCollectionViewController: FavoritesCollectionViewController
        
    private let searchViewController = SearchFavoritesViewController()
    private let favoritesEmptyResultController = ZeroFavoritesViewController()
    
    // MARK: - Initializers
    
    init(imageLoader: ImageLoader) {
        self.favoritesCollectionViewController = FavoritesCollectionViewController(imageLoader: imageLoader)
        super.init(nibName: nil, bundle: nil)
     }
    
     required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
     }
    
    // MARK: - UIViewController(*)
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        addSearchViewController()
        addFavoritesCollectionViewController()
        updatePresentationStyle()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: selectedStyle.buttonImage,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(changeContentLayout))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         loader?.getFavorites()
    }
    
    // MARK: - Private Methods
    
    private func addSearchViewController() {
        
        add(searchViewController)
        searchViewController.view.anchor(top: view.topAnchor,
                                         left: view.leftAnchor,
                                         bottom: view.bottomAnchor,
                                         right: view.rightAnchor)
    }
    
    private func addFavoritesCollectionViewController() {
        add(favoritesCollectionViewController)
        
        favoritesCollectionViewController.collection.anchor(
                                                   top: view.topAnchor,
                                                   left: view.leftAnchor,
                                                   bottom: view.bottomAnchor,
                                                   right: view.rightAnchor,
                                                   paddingTop: 125,
                                                   paddingLeft: 24,
                                                   paddingRight: 24)
    }
    
    private func addEmptyResultViewController() {
        add(favoritesEmptyResultController)
        
        favoritesEmptyResultController.view.anchor(top: view.topAnchor,
                                                   left: view.leftAnchor,
                                                   bottom: view.bottomAnchor,
                                                   right: view.rightAnchor,
                                                   paddingTop: 80)
    }
    
    private func updatePresentationStyle() {
        favoritesCollectionViewController.updatePresentation(with: styleDelegates[selectedStyle]!)
        navigationItem.rightBarButtonItem?.image = selectedStyle.buttonImage
    }
    
    @objc private func changeContentLayout() {
        let allCases = PresentationStyle.allCases
        guard let index = allCases.firstIndex(of: selectedStyle) else { return }
        let nextIndex = (index + 1) % allCases.count // циклический обход буфера
        selectedStyle = allCases[nextIndex]
        
    }
}

extension MainFavoritesViewController: SearchViewInput {
    
    func setMoviesData(movies: [MovieEntity]) {
        if movies.isEmpty {
            favoritesCollectionViewController.remove()
            addEmptyResultViewController()
        } else {
            addFavoritesCollectionViewController()
            favoritesEmptyResultController.remove()
            favoritesCollectionViewController.setData(movies: movies)
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
