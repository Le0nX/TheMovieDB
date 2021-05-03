//
//  TMDBURLCacheAsync.swift
//  TMDBNetwork
//
//  Created by Denis Nefedov on 29.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

public final class TMDBURLCacheAsync: URLCache {
    
    // MARK: - Private Properties
    
    private var cache = [String: CachedURLResponse]()
    private let lock = ReadWriteLock()

    // MARK: - Initializers
    
    public override init() {
        /// 1 необходим для того, чтобы были вызваны методы storeCachedResponse:forRequest
        super.init(memoryCapacity: 1, diskCapacity: 1, diskPath: nil)
    }
    
    // MARK: - Public Methods
    
    public override func getCachedResponse(for dataTask: URLSessionDataTask,
                                           completionHandler: @escaping (CachedURLResponse?) -> Void) {
        if let path = dataTask.currentRequest?.url?.absoluteString {
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                self.lock.readLock()
                completionHandler(self.cache[path])
                self.lock.unlock()
            }
        }
    }
    
    /// Сохранение кэшированного запроса
    /// - Parameters:
    ///   - cachedResponse: кэширванный запрос
    ///   - dataTask: дата таск
    public override func storeCachedResponse(_ cachedResponse: CachedURLResponse, for dataTask: URLSessionDataTask) {
        
        if let path = dataTask.currentRequest?.url?.absoluteString {
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                self.lock.writeLock()
                self.cache[path] = cachedResponse
                self.lock.unlock()
            }
        }
    }
    
    /// Удаление кэшированного запроса
    /// - Parameter dataTask: дата таск
    public override func removeCachedResponse(for dataTask: URLSessionDataTask) {
        
        if let path = dataTask.currentRequest?.url?.absoluteString {
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                
                self.lock.writeLock()
                self.cache[path] = nil
                self.lock.unlock()
            }
        }
    }
    
    /// Удаление всех закэшированных запросов
    public override func removeAllCachedResponses() {
        defer { lock.unlock() }
        
        lock.writeLock()
        cache.removeAll()
    }
}
