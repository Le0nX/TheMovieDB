//
//  RealmMovieEntry.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 16.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import DAO
import Foundation

final class RealmMovieEntry: RealmEntity {
    
    @objc dynamic public var title: String = ""
    @objc dynamic public var originalTitle: String = ""
    @objc dynamic public var overview: String = ""
    @objc dynamic public var popularity: Double = 0
    @objc dynamic public var voteCount: Int = 0
    @objc dynamic public var image: String = ""
    @objc dynamic public var id: Int = 0
    
    class func makeRealmMovieEntry(title: String,
                                   originalTitle: String,
                                   overview: String,
                                   popularity: Double,
                                   voteCount: Int,
                                   image: String,
                                   id: Int) -> RealmMovieEntry {
        
        let movie = RealmMovieEntry()
        movie.entityId = String(id)
        movie.id = id
        movie.title = title
        movie.originalTitle = originalTitle
        movie.overview = overview
        movie.popularity = popularity
        movie.voteCount = voteCount
        movie.image = image
        
        return movie
    }
}
