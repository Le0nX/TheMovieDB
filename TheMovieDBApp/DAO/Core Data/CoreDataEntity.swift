//
//  CoreDataEntity.swift
//  DAO
//
//  Created by Denis Nefedov on 16.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import CoreData

@objc(CoreDataEntity)
open class CoreDataEntity: NSManagedObject {
    @NSManaged public var entryId: String
}
