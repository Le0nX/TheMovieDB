//
//  FavoritesCollectionCollectionViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 02.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

protocol FavoritesCollectionViewControllerDelegate: class {
    
    /// Метод запроса картинки постера фильма
    /// - Parameter for: линк постера
    /// - Parameter completion: обрработчик
    func fetchImage(for: String, completion: @escaping (Data?) -> Void) -> UUID?
    
    /// Метод удаления таска из пула запущенных тасков, после того как постер был загружен
    /// - Parameter poster: часть url постера без baseUrl
    func cancelTask(for poster: UUID)
}

final class FavoritesCollectionViewController: UIViewController,
UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var dataSource: CollectionViewDataSource<MovieEntity, FavoriteCell>?
    
    public weak var delegate: FavoritesCollectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataSource()
        collection.delegate = self
        collection.register(UINib(nibName: "FavoriteCell", bundle: nil), forCellWithReuseIdentifier: "FavoritesCell")

        collection.backgroundColor = ColorName.background
        
        view.addSubview(collection)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Public methods
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 50
        let collectionViewSize = collectionView.frame.size.width - padding

        return CGSize(width: collectionViewSize / 2, height: collectionViewSize)
    }
    
    /// Инжектор данных
    /// - Parameter movies: фильмы
    func setData(movies: [MovieEntity]) {
        dataSource?.models = movies
        collection.reloadData()
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
                let uuid = self?.delegate?.fetchImage(for: poster) { data in
                    if let data = data {
                        cell.posterImage.image = UIImage(data: data)
                    }
                }
                
                cell.onReuse = {
                    self?.delegate?.cancelTask(for: uuid ?? UUID())
                }
            }
            
        }
        
        self.collection.dataSource = dataSource
    }
}
