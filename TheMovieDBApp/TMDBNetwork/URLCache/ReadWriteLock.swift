//
//  ReadWriteLock.swift
//  TMDBNetwork
//
//  Created by Denis Nefedov on 29.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

/// Read-Write lock для оптимизации блокировки
final class ReadWriteLock {
    
    // MARK: - Private Properites
    
    private var rwlock: pthread_rwlock_t = {
        var rwlock = pthread_rwlock_t()
        pthread_rwlock_init(&rwlock, nil)
        return rwlock
    }()
    
    // MARK: - Public Methods
    
    /// Блокировка на запись
    func writeLock() {
        pthread_rwlock_wrlock(&rwlock)
    }
    
    /// Блокировка на чтение
    func readLock() {
        pthread_rwlock_rdlock(&rwlock)
    }
    
    /// Разблокировка
    func unlock() {
        pthread_rwlock_unlock(&rwlock)
    }
}
