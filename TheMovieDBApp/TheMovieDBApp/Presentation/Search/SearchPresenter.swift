//
//  SearchPresenter.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 18.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

protocol SearchPresenterOutput {
    
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

final class SearchPresenter: SearchPresenterOutput {
    
    // MARK: - Private Properties
    
    private var moviesService: MovieService
    private var view: SearchViewInput
    
    // MARK: - Initializers
    
    init(_ view: SearchViewInput,
         moviesService: MovieService
    ) {
        self.view = view
        self.moviesService = moviesService
    }
        
    // MARK: - Public methods

    /// Метод обработки ввода названия фильма
    /// - Parameter name: название фильма
    func didEnteredMovie(name: String) {
                
        moviesService.searchFilm(name: name) { [weak self] result in
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
                
        let uuid = moviesService.fetchMoviePoster(for: poster) { result in
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
        moviesService.cancelTask(for: poster)
    }
}
