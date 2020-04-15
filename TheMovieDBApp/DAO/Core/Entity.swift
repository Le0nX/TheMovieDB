//
//  Entity.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 13.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

/// Базовый класс Entity
open class Entity: Hashable {
    
    // MARK: - Public Properties
    
    /// Уникальный ID
    public var entityId: String
    
    // MARK: - Initializers
    
    required public init() {
        entityId = UUID().uuidString
    }
    
    public init(entityId: String) {
        self.entityId = entityId
    }
    
    // MARK: - Public Methods

    /// Метод сравнения entities
    ///
    /// - Parameter other: entity compare with.
    /// - Returns: result of comparison.
    open func equals<T>(_ other: T) -> Bool where T: Entity {
        self.entityId == other.entityId
    }
    
    /// Hash для сравнения сущностей
    open func hash(into hasher: inout Hasher) {
        hasher.combine(entityId)
    }
}

/// Кастомный оператор `==` для `Entity`.
/// Необходимо переопределить у наследников
///
/// - Parameters:
///   - lhs: левый аргумент сравнения
///   - rhs: правый аргумент сравнения
/// - Returns: результат сравнения
public func == <T>(lhs: T, rhs: T) -> Bool where T: Entity {
    lhs.equals(rhs)
}
