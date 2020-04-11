//
//  FavoritesCollectionCollectionViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 02.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

/// ViewController коллекции избранного
final class FavoritesCollectionViewController: UIViewController {
         
    // MARK: - Public Properties
    
    public let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    // MARK: - Private Properties
    
    private let imageLoader: ImageLoader
    private var dataSource: CollectionViewDataSource<MovieEntity, FavoriteCell>?
    
    // MARK: - Initializers
    
    init(imageLoader: ImageLoader) {
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
     }
    
     required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
     }
    
    // MARK: - UIViewController(*)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataSource()
        collection.register(UINib(nibName: "FavoriteCell", bundle: nil), forCellWithReuseIdentifier: "FavoritesCell")

        collection.backgroundColor = ColorName.background
        
        view.addSubview(collection)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Public methods
    
    /// Инжектор данных
    /// - Parameter movies: фильмы
    func setData(movies: [MovieEntity]) {
        dataSource?.models = movies
        collection.reloadData()
    }
    
    func updatePresentation(with configuration: UICollectionViewDelegateFlowLayout) {
        collection.delegate = configuration
        collection.performBatchUpdates({
            collection.reloadData()
        }, completion: nil)
    }
    
    // MARK: - Private Methods
    
    private func setDataSource() {
        
        self.dataSource = CollectionViewDataSource<MovieEntity, FavoriteCell>(
            models: [],
            reuseIdentifier: "FavoritesCell"
        ) { [weak self] movie, cell in
            cell.movieName.text = movie.title
            cell.movieOriginalName.text = movie.originalTitle
            cell.popularityLabel.text = String(movie.popularity ?? 0)
            cell.ganreLabel.text = "жанр"

            if let poster = movie.image {
                let uuid = self?.imageLoader.fetchImage(for: poster) { data in
                    if let data = data {
                        cell.posterImage.image = DataConverter.toImage(from: data)
                    }
                }
                
                cell.onReuse = {
                    self?.imageLoader.cancelTask(for: uuid ?? UUID())
                }
            }
            
        }
        
        self.collection.dataSource = dataSource
    }
}
