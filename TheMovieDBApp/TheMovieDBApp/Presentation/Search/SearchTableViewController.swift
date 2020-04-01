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
    
    /// Метод запроса картинки постера фильма
    /// - Parameter for: линк постера
    /// - Parameter completion: обрработчик
    func fetchImage(for: String, completion: @escaping (Data?) -> Void) -> UUID?
    
    /// Метод удаления таска из пула запущенных тасков, после того как постер был загружен
    /// - Parameter poster: часть url постера без baseUrl
    func cancelTask(for poster: UUID)
    
    func pushVC(_ viewController: UIViewController)
}

final class SearchTableViewController: UITableViewController {
    
    // MARK: - Public Properties
    
    public weak var delegate: SearchTableViewControllerDelegate?
    
    // MARK: - Private Properties
    
    /// нужна strong ссылка на datasource, т.к. у tableView она weak
    private var dataSource: TableViewDataSource<MovieEntity, MoviesCell>?
    
    // MARK: - Initializers
    
    init() {
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
        100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! MoviesCell
        let detailsVC = MovieDetailsViewController(with: cell)
        let overviewVC = MovieOverviewScrollViewController(with: self.dataSource?.models[indexPath.row].overview ?? "")
        delegate?.pushVC(
            MainDetailsViewController(movieDetailsViewController: detailsVC, movieOverviewController: overviewVC))
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
    // MARK: - Private Methods
    
    private func setDataSource() {
        
        self.dataSource = TableViewDataSource<MovieEntity, MoviesCell>(
            models: [],
            reuseIdentifier: "MoviesCell"
        ) { [weak self] movie, cell in
            cell.movieName.text = movie.title
            cell.movieOriginalName.text = movie.originalTitle
            cell.popularityLabel.text = String(movie.popularity ?? 0)

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
        
        self.tableView.dataSource = dataSource
    }
}
