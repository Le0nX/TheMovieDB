//
//  RealmTranslator.swift
//  DAO
//
//  Created by Denis Nefedov on 15.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import RealmSwift

/// Перепаковщик из `Entity` в `RealmEntity` и обратно
public class RealmTranslator<Model: Entity, RealmModel: RealmEntity> {
    
    // MARK: - Public Methods
    
    /// Перезапись всех полей entity из Entry
    ///
    /// - Parameters:
    ///   - entity: entity типа `Model`
    ///   - fromEntry: запись типа `RealmModel`.
    public func fill(_ entity: Model, fromEntry: RealmModel) {
        fatalError("Abstact method")
    }
    
    /// Перезапись всех полей entry из entity
    ///
    /// - Parameters:
    ///   - entry: запись типа `RealmModel`.
    ///   - fromEntity: entity типа `Model`
    ///   - context: managed object context для текущей транзакции
    public func fill(_ entry: RealmModel, fromEntity: Model) {
        fatalError("Abstact method")
    }
    
    // Перезапись массива entry из entity
    ///
    /// - Parameters:
    ///   - entry: запись типа `RealmModel`.
    ///   - fromEntity: entity типа `Model`
    ///   - context: managed object context для текущей транзакции
    public func fill(_ entries: List<RealmModel>, fromEntities: [Model]) {
        var newEntries = [RealmModel]()
         
        /// зполняем массив RealmModel
        fromEntities.map { entity -> (RealmModel, Model) in
                
            let entry = entries.filter { $0.entityId == entity.entityId }.first
            
            if let entry = entry {
                return (entry, entity)
            } else {
                let entry = RealmModel()
                newEntries.append(entry)
                return (entry, entity)
            }
        }.forEach {
            self.fill($0.0, fromEntity: $0.1)
        }
        
        // если есть лишние, то удаляем
        if fromEntities.count < entries.count {
            let entityIds = fromEntities.map { $0.entityId }
            let deletedEntriesIndexes = entries.filter { !entityIds.contains($0.entityId) }
            deletedEntriesIndexes.forEach {
                if let index = entries.index(of: $0) {
                    entries.remove(at: index)
                }
            }
        } else {
            entries.append(objectsIn: newEntries)
        }
    }
}
