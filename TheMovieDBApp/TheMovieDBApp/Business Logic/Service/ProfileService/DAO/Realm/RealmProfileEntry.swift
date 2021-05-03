//
//  RealmProfileEntry.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 16.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import DAO
import Foundation

final class RealmProfileEntry: RealmEntity {
    
    // MARK: - Public Properties
    
    @objc dynamic public var id: Int = 0
    @objc dynamic public var name: String = ""
    @objc dynamic public var username: String = ""
    @objc dynamic public var image: Data?
    
    // MARK: - Initalizers
    
    class func makeRealmProfileEntry(id: Int,
                                     name: String,
                                     username: String,
                                     image: Data?) -> RealmProfileEntry {
        
        let profile = RealmProfileEntry()
        profile.id = id
        profile.name = name
        profile.username = username
        profile.image = image
        
        return profile
    }
}
