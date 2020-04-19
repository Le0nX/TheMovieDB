//
//  RealmProfileTranslator.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 16.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import DAO
import Foundation

final class RealmProfileTranslator: RealmTranslator<Profile, RealmProfileEntry> {
    
    required init() {
        super.init()
    }
    
    override func fill(_ entity: Profile?, fromEntry entry: RealmProfileEntry) {
        entity?.entityId = entry.entityId
        entity?.id = entry.id
        entity?.name = entry.name
        entity?.username = entry.username
        entity?.image = entry.image
    }

    override func fill(_ entry: RealmProfileEntry,
                       fromEntity entity: Profile) {
        
        if entry.entityId != entity.entityId {
            entry.entityId = entity.entityId
        }
        entry.id = entity.id
        entry.name = entity.name
        entry.username = entity.username
        entry.image = entity.image
    }
}
