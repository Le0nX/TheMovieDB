//
//  MovieMapper.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 04.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import TMDBNetwork

/// Маппер пришедшего DTO фильмов в модель фильмов
final class MovieMapper {
    
    // MARK: - Public methods
    
    /// Метод маппинга DTO в модель
    /// - Parameter movieDTO: DTO фильмов
    /// - Returns: модель фильмов
    static func map(from movieDTO: MovieResponse) -> [MovieEntity] {
        movieDTO.results?.map { MovieEntity(title: $0.title ?? "",
                                            originalTitle: $0.originalTitle ?? "",
                                            overview: $0.overview ?? "",
                                            popularity: $0.popularity,
                                            voteCount: $0.voteCount,
                                            genreIds: $0.genreIds,
                                            image: $0.posterPath,
                                            id: $0.id)
        } ?? []
    }
}
