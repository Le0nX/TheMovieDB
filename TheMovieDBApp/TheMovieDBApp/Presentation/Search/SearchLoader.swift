//
//  SearchLoader.swift
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
    
    /// Метод создания фаворита
    /// - Parameter movieId: id фильма
    func markFavorite(movieId: Int)
    
    /// Метод удаления фаворита
    /// - Parameter movieId: id фильма
    func unmarkFavorite(movieId: Int)
}

/// Лоадер-фасад экрана поиска фильмов,
/// который скрывает за собой работу других сервисов
final class SearchLoaderImpl: SearchLoader {
    
    // MARK: - Private Properties
    
    private let moviesService: MovieService
    private let favoriteService: FavoritesService
    private let accessService: AccessCredentialsService

    private let view: SearchViewInput
    
    // MARK: - Initializers
    
    init(_ view: SearchViewInput,
         favoriteService: FavoritesService,
         moviesService: MovieService,
         accessService: AccessCredentialsService
    ) {
        self.view = view
        self.moviesService = moviesService
        self.favoriteService = favoriteService
        self.accessService = accessService
    }
        
    // MARK: - Public methods

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
    
    func markFavorite(movieId: Int) {
        let model = FavoriteServiceMarkModel(accountId: accessService.credentials?.accountId ?? 0,
                                             sessionId: accessService.credentials?.session ?? "",
                                             movieId: movieId,
                                             isFavorite: true)
        favoriteService.markFavorite(for: model) { _ in }
    }
    
    func unmarkFavorite(movieId: Int) {
        let model = FavoriteServiceMarkModel(accountId: accessService.credentials?.accountId ?? 0,
                                             sessionId: accessService.credentials?.session ?? "",
                                             movieId: movieId,
                                             isFavorite: false)
        favoriteService.markFavorite(for: model) { _ in }
    }

}
