//
//  DAO.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 13.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

/// Интерфейс базового класса Data Access Object паттерна
public class DAO<Model: Entity> {
    
    // MARK: - Insert/update
    
    /// Сохранение новой entity или обновление имеющейся
    ///
    /// - Parameter entity: entity, которую нужно сохранить
    /// - Throws: ошибка, если entity не может быть сохранен
    public func persist(_ entity: Model) throws {
        preconditionFailure()
    }
      
    /// Сохранение новой entity или обновление имеющейся
    ///
    /// - Parameter entities: entity, которую нужно сохранить
    /// - Throws: ошибка, если entity не может быть сохранен
    public func persist(_ entities: [Model]) throws {
        preconditionFailure()
    }
    
    // MARK: - Read
    
    /// Чтение entity из DB generic типа Model
    ///
    /// - Parameter entityId: entity id.
    /// - Returns: имеющуюся entity или nil
    public func read(_ entityId: String) -> Model? {
        preconditionFailure()
    }
    
    /// Чтение всех entity из DB generic типа Model
    ///
    /// - Returns: массив entity
    public func read() -> [Model] {
        preconditionFailure()
    }
    
    // MARK: - Delete
    
    /// Удаление всех entity generic типа Model
    ///
    /// - Throws: ошибка, если entity не может быть удален
    public func erase() throws {
        preconditionFailure()
    }
    
    /// Удаление конкретной entity по id
    ///
    /// - Throws: ошибка, если entity не может быть удален
    public func erase(_ entityId: String) throws {
        preconditionFailure()
    }
    
}
