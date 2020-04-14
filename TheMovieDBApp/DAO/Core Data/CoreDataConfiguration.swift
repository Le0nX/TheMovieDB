//
//  CoreDataConfiguration.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 14.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import CoreData

/// Конфигурация CoreDataDAO
public struct CoreDataConfiguration {
    
    /// Имя контейнера также имя `*.xcdatamodelid` файла.
    public let containerName: String
    
    /// Тип хранения как в `CoreData`.  NSInMemoryStoreType
    public let storeType: String
    
    /// Опции для  persistence store
    public let options: [String: NSObject]
    
    /// URL  persistent store файла
    public let persistentStoreURL: URL?
    
    public init(
        containerName: String,
        storeType: String = NSSQLiteStoreType,
        options: [String: NSObject] =
            [
                NSMigratePersistentStoresAutomaticallyOption: true as NSObject,
                NSInferMappingModelAutomaticallyOption: true as NSObject
            ],
        persistentStoreURL: URL? = nil) {
        
        self.containerName = containerName
        self.storeType = storeType
        self.options = options
        self.persistentStoreURL = persistentStoreURL
    }
}
