//
//  FavoritesLoader.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 02.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

protocol FavoritesLoader {
    
    /// Метод получения фаворитов
    func getFavorites()
    
    /// Метод обработки ввода названия фильма
    /// - Parameter name: название фильма
    func didEnteredMovie(name: String)
}

/// Лоадер-фасад экрана  фаворитов,
/// который скрывает за собой работу других сервисов
final class FavoritesLoaderImpl: FavoritesLoader {
    
    // MARK: - Private Properties
    
    private let favoriteService: FavoritesService
    private let movieService: MovieService
    private let accessService: AccessCredentialsService
    
    private var userData: FavoriteServiceModel?
    
    private let view: SearchViewInput
        
    // MARK: - Initializers
    
    init(_ view: SearchViewInput,
         favoriteService: FavoritesService,
         movieService: MovieService,
         accessService: AccessCredentialsService
    ) {
        self.view = view
        self.favoriteService = favoriteService
        self.movieService = movieService
        self.accessService = accessService
    }
        
    // MARK: - Public methods
    
    func getFavorites() {
        let model = FavoriteServiceModel(sessionId: accessService.credentials?.session ?? "",
                                         profileId: accessService.credentials?.accountId ?? 0,
                                         page: 1)
        favoriteService.getFavorites(for: model) { [weak self] result in
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
                
        movieService.searchFilm(name: name) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.view.setMoviesData(movies: movies)
            case .failure(let error):
                self?.view.showError(error: error)
            }
        }
    }
}
