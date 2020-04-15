//
//  CoreDataMovieTranslator.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 15.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import DAO
import CoreData

final class CoreDataMovieTranslator: CoreDataTranslator<MovieEntity, CoreDataMovieEntry> {
    
    required init() {}

    override func fill(_ entity: MovieEntity?, fromEntry entry: CoreDataMovieEntry) {
        entity?.entityId = entry.entryId
        entity?.title = entry.title
        entity?.originalTitle = entry.originalTitle
        entity?.overview = entry.overview
        entity?.popularity = entry.popularity
        entity?.voteCount = entry.voteCount
        entity?.id = entry.id
    }

    override func fill(_ entry: CoreDataMovieEntry,
                       fromEntity entity: MovieEntity,
                       in context: NSManagedObjectContext) {
        
        entry.entryId = entity.entityId
        entry.title = entity.title
        entry.originalTitle = entity.originalTitle
        entry.overview = entity.overview
        entry.popularity = entity.popularity ?? 0
        entry.voteCount = entity.voteCount ?? 0
        entry.id = entity.id
    }

}
