//
//  SearchPresenter.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 18.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

protocol SearchLoader {
    
    /// Метод обработки ввода названия фильма
    /// - Parameter name: название фильма
    func didEnteredMovie(name: String)
}

/// Лоадер-фасад экрана поиска фильмов,
/// который скрывает за собой работу других сервисов
final class SearchLoaderImpl: SearchLoader {
    
    // MARK: - Private Properties
    
    private let moviesService: MovieService

    private let view: SearchViewInput
    
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
}
