//
//  DetailsModelConverter.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 05.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

final class DetailsModelConverter {
    
    // MARK: - Public methods
    
    static func toDetailsModel(from cell: MoviesCell, with overview: String?) -> MovieDetail {
        MovieDetail(movieName: cell.movieName.text,
                    genre: cell.ganreLabel.text,
                    movieOriginalName: cell.movieOriginalName.text,
                    popularity: cell.popularityLabel.text,
                    votes: cell.voteCountLabel.text,
                    poster: cell.posterImage.image,
                    overview: overview,
                    movieId: cell.movieId)
    }
}
