//
//  DetailsModelConverter.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 05.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

/// Конввертер ячейки в модель для экрана деталей о фильме
final class DetailsModelConverter {
    
    // MARK: - Public methods
    
    static func toDetailsModel(from cell: MoviesCell, with overview: String?) -> MovieDetail {
        MovieDetail(movieName: cell.movieNameLabel,
                    genre: cell.genre,
                    movieOriginalName: cell.movieOriginalNameLabel,
                    popularity: cell.popularity,
                    votes: cell.vote,
                    poster: cell.poster,
                    overview: overview,
                    movieId: cell.movieId)
    }
}
