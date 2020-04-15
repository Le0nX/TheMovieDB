//
//  CoreDataTranslator.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 14.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import CoreData

/// Перепаковщик из `Entity` в `CoreDataModel` и обратно
public class CoreDataTranslator<Model: Entity, CoreDataModel: NSManagedObject> {
    
    // MARK: - Public Properties
    
    /// вспомогательное свойство `CoreDataDAO`.
    public var entryClassName: String {
        NSStringFromClass(CoreDataModel.self).components(separatedBy: ".").last!
    }
    
    // MARK: - Public Methods
    
    /// Перезапись всех полей entity из Entry
    ///
    /// - Parameters:
    ///   - entity: entity типа `Model`
    ///   - fromEntry: запись типа `CoreDataModel`.
    public func fill(_ entity: Model, fromEntry: CoreDataModel) {
        fatalError("Abstact method")
    }
    
    /// Перезапись всех полей entity из Entry
    ///
    /// - Parameters:
    ///   - entry: запись типа `CoreDataModel`.
    ///   - fromEntity: entity типа `Model`
    ///   - context: managed object context для текущей транзакции
    public func fill(_ entry: CoreDataModel, fromEntity: Model, in context: NSManagedObjectContext) {
        fatalError("Abstact method")
    }
}
