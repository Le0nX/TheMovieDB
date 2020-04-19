//
//  CoreDataDAO.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 14.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import CoreData

/// Реализация  Data Access Object для CoreData
public final class CoreDataDAO<Model: Entity, CoreDataModel: NSManagedObject>: DAO<Model> {
    
    // MARK: - Private Properties
    
    /// Транслятор для текущих `Model` и `CoreDataModel` типов.
    private var translator: CoreDataTranslator<Model, CoreDataModel>
    
    /// Persistent store cooridnator. Может быть сконфигурирован с помощью `CoreDataConfiguration`.
    /// Необходим для маппинга данных из хранилища в NSManagedObjectModel
    private let persistentStoreCoordinator: NSPersistentStoreCoordinator
    
    /// Managed object context. Контекст создается во время каждой транзакции в зависимости
    /// от текущей очереди  – main или backgoround.
    private var context: NSManagedObjectContext {
         let context = Thread.isMainThread
            ? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            : NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
     
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.shouldDeleteInaccessibleFaults = true // silent ошибки
        context.automaticallyMergesChangesFromParent = true
        
        return context
    }
    
    // MARK: - Initializers
    
    /// Создает инстанс с попмощью `translator` и `configuration`.
    ///
    /// - Parameters:
    ///   - translator: транслятор для `Model` и `CoreDataModel` типов.
    ///   - configuration: конфигурация. Смотри `CoreDataConfiguration`.
    /// - Throws: ошибка, если загрузка persistence store не удалась.
    public convenience init(_ translator: CoreDataTranslator<Model, CoreDataModel>,
                            configuration: CoreDataConfiguration) throws {
        
        let persistentContainer = NSPersistentContainer(name: configuration.containerName)
        
        persistentContainer.persistentStoreDescriptions
            .forEach { description in
                configuration.options
                    .forEach {
                        description.setOption($0.value, forKey: $0.key)
                    }
                description.type = configuration.storeType
                
                if configuration.persistentStoreURL != nil {
                    description.url = configuration.persistentStoreURL
                }
            }
        
        var error: Error?
        persistentContainer.loadPersistentStores { _, e in
            error = e
        }
        if let error = error { throw error }
        
        self.init(translator, persistentContainer: persistentContainer)
    }
    
    /// Создает инстанс с попмощью `translator` и `persistentContainer`.
    ///
    /// - Parameters:
    ///   - translator: транслятор для `Model` и `CoreDataModel` типов.
    ///   - persistentContainer: инициализированный NSPersistentContainer с загруженными сторами
    public convenience init(_ translator: CoreDataTranslator<Model, CoreDataModel>,
                            persistentContainer: NSPersistentContainer) {
        
        self.init(
            translator,
            persistentStoreCoordinator: persistentContainer.persistentStoreCoordinator
        )
    }
    
    /// Создает сущность с указанными `translator` и `persistentStoreCoordinator`.
    ///
    /// - Parameters:
    ///   - translator: транслятор для `Model` и `CoreDataModel` типов.
    ///   - persistentStoreCoordinator: инициализированный NSPersistentStoreCoordinator
    ///                                 из  NSPersistentContainer с загруженными сторами
    public init(_ translator: CoreDataTranslator<Model, CoreDataModel>,
                persistentStoreCoordinator: NSPersistentStoreCoordinator) {
        
        self.translator = translator
        self.persistentStoreCoordinator = persistentStoreCoordinator
        
        super.init()
    }
    
    // MARK: - Public Methods
    
    // MARK: - Insert/update
    
    /// Сохранение новой entity или обновление имеющейся
    ///
    /// - Parameter entity: entity, которую нужно сохранить
    /// - Throws: ошибка, если entity не может быть сохранен
    public override func persist(_ entity: Model) throws {
        var error: Error?
        let context = self.context
        
        context.performAndWait { [weak self] in
            guard let self = self else { return }
            
            do {
                if self.isEntryExist(entity.entityId, inContext: context) {
                    try self.update(entity, inContext: context)
                } else {
                    try self.create(entity, inContext: context)
                }
            } catch let e {
                error = e
            }
        }
        
        if let error = error { throw error }
    }
      
    /// Сохранение новой entity или обновление имеющейся
    ///
    /// - Parameter entities: entity, которую нужно сохранить
    /// - Throws: ошибка, если entity не может быть сохранен
    public override func persist(_ entities: [Model]) throws {
        var error: Error?
        
        let context = self.context
        
        context.performAndWait { [weak self] in
            guard let self = self else { return }
            
            entities.forEach { entity in
                if self.isEntryExist(entity.entityId, inContext: context) {
                    let existingEntries = self.fetchEntries(entity.entityId, inContext: context)
                    existingEntries.forEach {
                        self.translator.fill($0, fromEntity: entity, in: context)
                    }
                } else if let entry = NSEntityDescription.insertNewObject(
                    forEntityName: self.translator.entryClassName,
                    into: context) as? CoreDataModel {
                    
                    self.translator.fill(entry, fromEntity: entity, in: context)
                }
            }
            
            do {
                try context.save()
            } catch let e {
                error = e
                context.rollback()
            }
        }
        
        if let error = error { throw error }
    }
    
    // MARK: - Read
    
    /// Чтение entity из DB generic типа Model
    ///
    /// - Parameter entityId: entity id.
    /// - Returns: имеющуюся entity или nil
    public override func read(_ entityId: String) -> Model? {
        let context = self.context
        var entity: Model?
            
        context.performAndWait { [weak self] in
            guard
                let `self` = self,
                let entries = try? context.fetch(self.request(entityId)),
                let entry = entries.first
                else {
                    return
            }
            
            let model = Model()
            self.translator.fill(model, fromEntry: entry)
            entity = model
        }
        
        return entity
    }
    
    /// Чтение всех entity из DB generic типа Model
    ///
    /// - Returns: массив entity
    public override func read() -> [Model] {
        
        let context = self.context
        var models: [Model]?
        
        context.performAndWait { [weak self] in
            guard let `self` = self else { return }
            
            models = self.fetchEntries(inContext: context).compactMap {
                    let entity = Model()
                    self.translator.fill(entity, fromEntry: $0)
                    return entity
            }
        }
        
        return models ?? []
    }
    
    // MARK: - Delete
    
    /// Удаление всех entity generic типа Model
    ///
    /// - Throws: ошибка, если entity не может быть удален
    public override func erase() throws {
        var error: Error?
        
        let context = self.context
        
        context.performAndWait { [weak self] in
            guard let `self` = self else { return }
            
            self.fetchEntries(inContext: context)
                .forEach(context.delete)
            
            do {
                try context.save()
            } catch let e {
                error = e
                context.rollback()
            }
        }
        
        if let error = error { throw error }
    }
    
    /// Удаление конкретной entity по id
    ///
    /// - Throws: ошибка, если entity не может быть удален
    public override func erase(_ entityId: String) throws {
        var error: Error?
        
        let context = self.context
        
        context.performAndWait { [weak self] in
            guard let `self` = self else { return }
            
            self.fetchEntries(entityId, inContext: context)
                .forEach(context.delete)
            do {
                try context.save()
            } catch let e {
                error = e
                context.rollback()
            }
            
        }
        
        if let error = error { throw error }
    }
    
    // MARK: - Private Properties
    
    /// Метод проверки наличия поля в бд
    /// - Parameters:
    ///   - entryId: id
    ///   - context: текущий контекст
    /// - Returns: имеется ли уже в бд или нет
    private func isEntryExist(_ entryId: String,
                              inContext context: NSManagedObjectContext) -> Bool {
        
        let existingEntries = fetchEntries(entryId, inContext: context)
        return !existingEntries.isEmpty
    }
    
    /// Получение NSManagedObject типа `CoreDataModel`
    /// - Parameters:
    ///   - entryId: id
    ///   - context: текущиий контекст
    /// - Returns: массив CoreDataModel или []
    private func fetchEntries(_ entryId: String,
                              inContext context: NSManagedObjectContext) -> [CoreDataModel] {
        
        let request = self.request(entryId)
        let entries = try? context.fetch(request)
        return entries ?? []
    }
    
    /// Создание NSFetchRequest для отфильтрованной выборки из модели
    /// - Parameter entryId: id
    /// - Returns: NSFetchRequest для  `CoreDataModel`
    private func request(_ entryId: String) -> NSFetchRequest<CoreDataModel> {
        let request = NSFetchRequest<CoreDataModel>(entityName: translator.entryClassName)
        request.predicate = NSPredicate(format: "entryId == %@", argumentArray: [entryId])
        
        return request
    }
    
    /// Получение массива NSManagedObject типа `CoreDataModel` с фильтрами
    /// - Parameters:
    ///   - predicate:NSPredicate
    ///   - sortDescriptors: NSSortDescriptor
    ///   - context: текущий контекст
    /// - Returns: массив NSManagedObject типа `CoreDataModel`
    private func fetchEntries(_ predicate: NSPredicate? = nil,
                              sortDescriptors: [NSSortDescriptor] = [],
                              inContext context: NSManagedObjectContext) -> [CoreDataModel] {
        
        let request = self.request(predicate, sortDescriptors: sortDescriptors)
        let entries = try? context.fetch(request)
        return entries ?? []
    }
    
    /// Создание NSFetchRequest для отфильтрованной выборки из модели
    /// - Parameters:
    ///   - predicate: NSPredicate
    ///   - sortDescriptors: NSSortDescriptor
    /// - Returns: NSFetchRequest типа `CoreDataModel`
    private func request(_ predicate: NSPredicate?,
                         sortDescriptors: [NSSortDescriptor]) -> NSFetchRequest<CoreDataModel> {
        
        let request = NSFetchRequest<CoreDataModel>(entityName: translator.entryClassName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        return request
    }
    
    /// Перезапись текущей entity типа `Model`
    /// - Parameters:
    ///   - entity: entity типа `Model`
    ///   - context: текущий контекст
    /// - Throws: ошибка, если не удалось сохранить контекст
    private func update(_ entity: Model, inContext context: NSManagedObjectContext) throws {
        let existingEntries = fetchEntries(entity.entityId, inContext: context)

        existingEntries.forEach {
            translator.fill($0, fromEntity: entity, in: context)
        }
            
        try context.save()
    }
    
    /// Создать новую Entity в бд
    /// - Parameters:
    ///   - entity: entity типа `Model`
    ///   - context: текущий контекст
    /// - Throws: ошибка, если не удалось сохранить контекст
    private func create(_ entity: Model, inContext context: NSManagedObjectContext) throws {
        guard let entry = NSEntityDescription.insertNewObject(
            forEntityName: translator.entryClassName,
            into: context) as? CoreDataModel
        else {
            return
        }
        
        translator.fill(entry, fromEntity: entity, in: context)
        
        try context.save()
    }
}
