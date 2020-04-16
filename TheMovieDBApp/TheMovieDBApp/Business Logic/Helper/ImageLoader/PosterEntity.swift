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
    
    public var id: String
    public var poster: Data?
    
    init(id: String, poster: Data? = nil) {
        self.id = id
        self.poster = poster
        super.init()
    }
    
    required init() {
        self.id = ""
        self.poster = nil
        super.init()
    }
}
