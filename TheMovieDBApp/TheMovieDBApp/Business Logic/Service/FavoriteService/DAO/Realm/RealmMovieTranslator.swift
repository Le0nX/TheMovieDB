//
//  RealmMovieTranslator.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 16.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import DAO
import Foundation

final class RealmMovieTranslator: RealmTranslator<MovieEntity, RealmMovieEntry> {
    
    required init() {
        super.init()
    }
    
    override func fill(_ entity: MovieEntity?, fromEntry entry: RealmMovieEntry) {
        entity?.entityId = entry.entityId
        entity?.title = entry.title
        entity?.originalTitle = entry.originalTitle
        entity?.overview = entry.overview
        entity?.popularity = entry.popularity
        entity?.voteCount = entry.voteCount
        entity?.id = entry.id
    }

    override func fill(_ entry: RealmMovieEntry,
                       fromEntity entity: MovieEntity) {
        
        entry.entityId = entity.entityId
        entry.title = entity.title
        entry.originalTitle = entity.originalTitle
        entry.overview = entity.overview
        entry.popularity = entity.popularity ?? 0
        entry.voteCount = entity.voteCount ?? 0
        entry.id = entity.id
    }

}
