//
//  RealmPosterEntry.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 16.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import DAO
import Foundation

final class RealmPosterEntry: RealmEntity {
    
    // MARK: Public Properties
    
    @objc dynamic public var id: String = ""
    @objc dynamic public var poster: Data?
    
    // MARK: - Initalizers
    
    class func makeRealmPosterEntry(id: String,
                                    poster: Data?) -> RealmPosterEntry {
        
        let profile = RealmPosterEntry()
        profile.id = id
        profile.poster = poster
        
        return profile
    }
}
