//
//  RealmEntity.swift
//  DAO
//
//  Created by Denis Nefedov on 15.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Realm
import RealmSwift

/// Родительский класс для `Realm` entity.
open class RealmEntity: Object {
    
    // MARK: - Public Properties
    
    /// Уникальный ID  entity
    @objc dynamic public var entityId: String
    
    // MARK: - Initializers
    
    public init(entityId: String) {
        self.entityId = entityId
        super.init()
    }

    public required init() {
        self.entityId = UUID().uuidString
        super.init()
    }
    
    required public init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
    
    /// Возврат Primary Key для таблицы
    /// - Returns: primary key
    override open class func primaryKey() -> String? {
        "entityId"
    }
    
}
