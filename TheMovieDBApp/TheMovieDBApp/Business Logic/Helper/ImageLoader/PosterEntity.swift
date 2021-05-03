//
//  PosterEntity.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 16.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import DAO
import Foundation

final class PosterEntity: Entity {
    
    public var poster: Data?
    
    init(id: String, poster: Data? = nil) {
        self.poster = poster
        super.init(entityId: id)
    }
    
    required init() {
        self.poster = nil
        super.init()
    }
}
