//
//  Movie.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 18.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import DAO
import Foundation

/// Бизнес-модель фильма
final class MovieEntity: Entity {
    
    // MARK: - Public  Properties
    
    var title: String
    var originalTitle: String
    var overview: String
    var popularity: Double?
    var voteCount: Int?
    var genreIds: [Int]?
    var image: String?
    var id: Int
    
    // MARK: - Initalizers
    
    init(title: String,
         originalTitle: String,
         overview: String,
         popularity: Double? = nil,
         voteCount: Int? = nil,
         genreIds: [Int]? = nil,
         image: String?,
         id: Int) {
        
        self.title = title
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.voteCount = voteCount
        self.genreIds = genreIds
        self.image = image
        self.id = id
        
        super.init(entityId: String(id))
    }
    
    required init() {
        self.title = ""
        self.originalTitle = ""
        self.overview = ""
        self.id = 0
        self.image = ""
        super.init()
    }
}
