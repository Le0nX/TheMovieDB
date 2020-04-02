//
//  FavoritesPresenter.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 02.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

protocol FavoritesPresenterOutput {
    
    /// Метод получения фаворитов
    func getFavorites()
    
    /// Метод обработки ввода названия фильма
    /// - Parameter name: название фильма
    func didEnteredMovie(name: String)
    
    /// Метод запроса картинки постера фильма
    /// - Parameter for: линк постера
    /// - Parameter completion: обрработчик
    func fetchImage(for: String, completion: @escaping (Data?) -> Void) -> UUID?
    
    /// Метод удаления таска из пула запущенных тасков, после того как постер был загружен
    /// - Parameter poster: часть url постера без baseUrl
    func cancelTask(for poster: UUID)
}

final class FavoritesPresenter: FavoritesPresenterOutput {
    
    // MARK: - Private Properties
    
    private var favoriteService: FavoritesService
    private var view: SearchViewInput
    
    // MARK: - Initializers
    
    init(_ view: SearchViewInput,
         favoriteService: FavoritesService
    ) {
        self.view = view
        self.favoriteService = favoriteService
    }
        
    // MARK: - Public methods
    
    func getFavorites() {
        favoriteService.getFavorites { [weak self] result in
            switch result {
            case .success(let movies):
                self?.view.setMoviesData(movies: movies)
            case .failure(let error):
                self?.view.showError(error: error)
            }
        }
    }

    /// Метод обработки ввода названия фильма
    /// - Parameter name: название фильма
    func didEnteredMovie(name: String) {
                
        favoriteService.searchFilm(name: name) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.view.setMoviesData(movies: movies)
            case .failure(let error):
                self?.view.showError(error: error)
            }
        }
    }
    
    /// Метод запроса картинки постера фильма
    /// - Parameter for: линк постера
    /// - Parameter completion: обрработчик
    func fetchImage(for poster: String, completion: @escaping (Data?) -> Void) -> UUID? {
                
        let uuid = favoriteService.fetchMoviePoster(for: poster) { result in
            DispatchQueue.main.async {
                            
                switch result {
                case .success(let data):
                    completion(data)
                case .failure:
                    completion(nil)
                }
            }
            
        }
        
        return uuid
    }
    
    /// Метод удаления таска из пула запущенных тасков, после того как постер был загружен
    /// - Parameter poster: часть url постера без baseUrl
    func cancelTask(for poster: UUID) {
        favoriteService.cancelTask(for: poster)
    }
}
