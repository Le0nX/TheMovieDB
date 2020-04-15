//
//  RealmDAO.swift
//  DAO
//
//  Created by Denis Nefedov on 15.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Realm
import RealmSwift

/// Реализация  Data Access Object для Realm
public final class RealmDAO<Model: Entity, RealmModel: RealmEntity>: DAO<Model> {
    
    // MARK: - Private Properties
    
    /// Транслятор для текущих `RealmModel` и `RealmModel` типов.
    private let translator: RealmTranslator<Model, RealmModel>
    
    private let configuration: Realm.Configuration
    
    // MARK: - Initializers
    
    public init(_ translator: RealmTranslator<Model, RealmModel>,
                configuration: RealmConfiguration) {
        
        self.translator = translator
        self.configuration = configuration.makeRealmConfiguration()
        super.init()
    }
    
    // MARK: - Public Methods
    
    // MARK: - Insert/update
    
    /// Сохранение новой entity или обновление имеющейся
    ///
    /// - Parameter entity: entity, которую нужно сохранить
    /// - Throws: ошибка, если entity не может быть сохранен
    public override func persist(_ entity: Model) throws {
        if let entry = try realmRead(entity.entityId) {
            try autoreleasepool { // TODO: - посмотри
                try realm().beginWrite()
                translator.fill(entry, fromEntity: entity)
                try realm().commitWrite()
            }
        } else {
            let entry = RealmModel()
            translator.fill(entry, fromEntity: entity)
            try realmWrite(entry)
        }
    }
      
    /// Сохранение новой entity или обновление имеющейся
    ///
    /// - Parameter entities: entity, которую нужно сохранить
    /// - Throws: ошибка, если entity не может быть сохранен
    public override func persist(_ entities: [Model]) throws {
        let entries = List<RealmModel>()
        for entity in entities {
            if let entry = try? realmRead(entity.entityId) {
                entries.append(entry)
            }
        }
        
        let realm = try self.realm()
        try autoreleasepool {
            realm.beginWrite()
            translator.fill(entries, fromEntities: entities)
            
            entries.forEach {
                realm.create(RealmModel.self, value: $0, update: .all)
            }
            
            try realm.commitWrite()
        }
    }
    
    // MARK: - Read
    
    /// Чтение entity из DB generic типа Model
    ///
    /// - Parameter entityId: entity id.
    /// - Returns: имеющуюся entity или nil
    public override func read(_ entityId: String) -> Model? {
        guard let entry = try? realmRead(entityId) else { return nil }
        
        let entity = Model()
        translator.fill(entity, fromEntry: entry)
        
        return entity
    }
    
    /// Чтение всех entity из DB generic типа Model
    ///
    /// - Returns: массив entity
    public override func read() -> [Model] {
        do {
            let realm = try self.realm()
            let results = realm.objects(RealmModel.self)
            return results.map {
                let entity = Model()
                self.translator.fill(entity, fromEntry: $0)
                return entity
            }
        } catch {
            return []
        }
    }
    
    // MARK: - Delete
    
    /// Удаление всех entity generic типа Model
    ///
    /// - Throws: ошибка, если entity не может быть удален
    public override func erase() throws {
        let realm = try self.realm()
        try realm.write {
            realm.deleteAll()
        }
    }
    
    /// Удаление конкретной entity по id
    ///
    /// - Throws: ошибка, если entity не может быть удален
    public override func erase(_ entityId: String) throws {
        guard let entry = try realmRead(entityId) else {
            return
        }
        try self.realm().write {
            delete(entry)
        }
    }
    
    // MARK: - Private Methods
    
    private func realm() throws -> Realm {
        let realm = try Realm(configuration: configuration)
        return realm
    }
    
    private func realmRead(_ entryId: String) throws -> RealmModel? {
        let realm = try self.realm()
        return realm.object(ofType: RealmModel.self, forPrimaryKey: entryId)
    }
    
    private func realmWrite(_ entry: RealmModel) throws {
        let realm = try self.realm()
        try realm.write {
            realm.create(RealmModel.self, value: entry, update: .all)
        }
    }
    
    private func delete(_ object: AnyObject?) {
        if let realmObject = object as? Object {
            try? self.realm().delete(realmObject)
        }
    }
}
