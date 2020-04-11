//
//  Movie.swift
//  TMDBNetwork
//
//  Created by Denis Nefedov on 17.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

/// DTO MovieEndpoint'a
public struct MovieResponse: Decodable {
    public let page: Int?
    public let results: [Movie]?
    public let totalResults: Int?
    public let totalPages: Int?
}

/// DTO фильма
public struct Movie: Decodable {
    public let posterPath: String?
    public let adult: Bool?
    public let overview: String?
    public let releaseDate: String?
    public let genreIds: [Int]?
    public let originalTitle: String?
    public let originalLanguage: String?
    public let title: String?
    public let backdropPath: String?
    public let popularity: Double?
    public let voteCount: Int?
    public let video: Bool?
    public let voteAverage: Double?
    public let id: Int
}
