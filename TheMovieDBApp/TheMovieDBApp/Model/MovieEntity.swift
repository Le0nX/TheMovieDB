//
//  Movie.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 18.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

struct MovieEntity {
    let title: String
    let originalTitle: String
    let popularity: Double?
    let voteCount: Int?
    let genreIds: [Int]?
    let image: String?
}
