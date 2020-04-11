//
//  SearchTableViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 31.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import UIKit

protocol SearchTableViewControllerDelegate: class {
    
    /// Открыть детали фильма
    /// - Parameter model: модель деталей фильма
    func openDetailsViewController(with model: MovieDetail)
}

/// ViewController таблицы результатов поиска
final class SearchTableViewController: UITableViewController {
    
    // MARK: - Public Properties
    
    public weak var delegate: SearchTableViewControllerDelegate?
    
    // MARK: - Private Properties
    
    /// нужна strong ссылка на datasource, т.к. у tableView она weak
    private var dataSource: TableViewDataSource<MovieEntity, MoviesCell>?
    
    private let imageLoader: ImageLoader
    
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
        tableView.register(UINib(nibName: "MoviesCell", bundle: nil), forCellReuseIdentifier: "MoviesCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = ColorName.background
        tableView.showsVerticalScrollIndicator = false
        
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        
        setDataSource()
    }
    
    // MARK: - Public methods
    
    func searhTableViewSetData(movies: [MovieEntity]) {
        dataSource?.models = movies
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        MoviesCell.cellHight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? MoviesCell else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        let detailsModel = DetailsModelConverter.toDetailsModel(from: cell,
                                                                with: self.dataSource?.models[indexPath.row].overview)

        delegate?.openDetailsViewController(with: detailsModel)
    }
        
    // MARK: - Private Methods
    
    private func setDataSource() {
        
        self.dataSource = TableViewDataSource<MovieEntity, MoviesCell>(
            models: [],
            reuseIdentifier: "MoviesCell"
        ) { [weak self] movie, cell in
            cell.movieId = movie.id
            cell.movieNameLabel = movie.title
            cell.movieOriginalNameLabel = movie.originalTitle
            cell.popularity = String(movie.popularity ?? 0)

            if let poster = movie.image {
                let uuid = self?.imageLoader.fetchImage(for: poster) { data in
                    if let data = data {
                        cell.poster = DataConverter.toImage(from: data)
                    }
                }
                
                cell.onReuse = {
                    self?.imageLoader.cancelTask(for: uuid ?? UUID())
                }
            }
            
        }
        
        self.tableView.dataSource = dataSource
    }
}
