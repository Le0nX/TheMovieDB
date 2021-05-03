//
//  Profile.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 17.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import DAO
import Foundation

/// бизнес-модель профиля 
final class Profile: Entity {
    
    // MARK: - Public Properties
    
    var id: Int = 0
    var name: String = ""
    var username: String = ""
    var image: Data?
    
    // MARK: - Initalizers
    
    init(id: Int,
         name: String,
         username: String,
         image: Data?) {
        
        self.id = id
        self.name = name
        self.username = username
        self.image = image
        super.init()
    }
    
    required init() {
        super.init()
    }
}
