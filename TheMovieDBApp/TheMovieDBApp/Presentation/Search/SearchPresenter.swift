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
    func fetchImage(for: String, completion: @escaping (Data?) -> Void)
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
                print(error)
            }
        }
    }
    
    /// Метод запроса картинки постера фильма
    /// - Parameter for: линк постера
    /// - Parameter completion: обрработчик
    func fetchImage(for poster: String, completion: @escaping (Data?) -> Void) {
                
        moviesService.fetchMoviePoster(for: poster) { result in
            DispatchQueue.main.async {
                            
                switch result {
                case .success(let data):
                    completion(data)
                case .failure:
                    completion(nil)
                }
            }
            
        }
    }
}
