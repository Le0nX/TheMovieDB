//
//  CoreDataMovieEntity.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 16.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import DAO
import CoreData

@objc(CoreDataMovieEntry)
public final class CoreDataMovieEntry: CoreDataEntity {
    
    // MARK: - Public Properties
    
    @NSManaged public var title: String
    @NSManaged public var originalTitle: String
    @NSManaged public var overview: String
    @NSManaged public var popularity: Double
    @NSManaged public var voteCount: Int
    @NSManaged public var image: NSData?
    @NSManaged public var id: Int

    // MARK: - Public Methods
    
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<CoreDataMovieEntry> {
        NSFetchRequest<CoreDataMovieEntry>(entityName: "CoreDataMovieEntity")
    }
}
