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
}

/// Лоадер-фасад экрана  фаворитов,
/// который скрывает за собой работу других сервисов
final class FavoritesLoaderImpl: FavoritesLoader {
    
    // MARK: - Private Properties
    
    private let favoriteService: FavoritesService
    private let accessService: AccessCredentialsService
    
    private var userData: FavoriteServiceModel?
    
    private let view: SearchViewInput
        
    // MARK: - Initializers
    
    init(_ view: SearchViewInput,
         favoriteService: FavoritesService,
         accessService: AccessCredentialsService
    ) {
        self.view = view
        self.favoriteService = favoriteService
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
}
