//
//  RealmPosterTranslator.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 16.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

import DAO
import Foundation

final class RealmPosterTranslator: RealmTranslator<PosterEntity, RealmPosterEntry> {
    
    required init() {
        super.init()
    }
    
    override func fill(_ entity: PosterEntity?, fromEntry entry: RealmPosterEntry) {
        entity?.entityId = entry.entityId
        entity?.id = entry.id
        entity?.poster = entry.poster
    }

    override func fill(_ entry: RealmPosterEntry,
                       fromEntity entity: PosterEntity) {
        
        if entry.entityId != entity.entityId {
            entry.entityId = entity.entityId
        }
        entry.id = entity.id
        entry.poster = entity.poster
    }
}
