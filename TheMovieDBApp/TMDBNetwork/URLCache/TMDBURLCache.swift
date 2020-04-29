//
//  TMDBURLCache.swift
//  TMDBNetwork
//
//  Created by Denis Nefedov on 29.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

public final class TMDBURLCache: URLCache {
    
    // MARK: - Private Properties
    
    private var cache = [String: CachedURLResponse]()
    private let lock = ReadWriteLock()

    // MARK: - Initializers
    
    public override init() {
        /// 1 необходим для того, чтобы были вызваны методы storeCachedResponse:forRequest
        super.init(memoryCapacity: 1, diskCapacity: 1, diskPath: nil)
    }
    
    // MARK: - Public Methods
    
    /// Вызывается NSURLConnection, когда он хочет узнать, есть ли что-то в кэше
    /// - Parameter request: запрос
    /// - Returns: кэшированый запрос
    public override func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        defer { lock.unlock() }
                
        // проверяем, что кэширование разрешено запросом
        if request.cachePolicy == NSURLRequest.CachePolicy.reloadIgnoringCacheData {
            debug("reloadIgnoringCacheData")
            return nil
        }
        
        if let path = request.url?.absoluteString {
            debug("getting cache for: \(path)")
            lock.readLock()
            return cache[path]
        } else {
            return nil
        }
    }
    
    /// Вызывается NSURLConnection, когда запрос выполнен
    /// - Parameters:
    ///   - cachedResponse: кэшированый запрос
    ///   - request: запрос
    public override func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
        defer { lock.unlock() }
        
        // ошибки не сохраняются
        if let httpResponse = cachedResponse.response as? HTTPURLResponse {
            if httpResponse.statusCode >= 400 {
                debug("""
                        Не кэшируем ошибку: \(httpResponse.statusCode)
                         для страницы : \(request.url?.absoluteString ?? "") \(httpResponse.debugDescription)
                        """)
                return
            }
        }
        
        // проверяем, что кэширование разрешено запросом
        if request.cachePolicy == NSURLRequest.CachePolicy.reloadIgnoringCacheData {
            debug("reloadIgnoringCacheData")
            return
        }
        
        // проверяем, что кэширование разрешено заголовками Cache-Control или Pragma у нашего респонза
        if let httpResponse = cachedResponse.response as? HTTPURLResponse {
            if let cacheControl = httpResponse.allHeaderFields["Cache-Control"] as? String {
                if cacheControl.lowercased().contains("no-cache") || cacheControl.lowercased().contains("no-store") {
                    debug("Cache-Control")
                    return
                }
            }

            if let cacheControl = httpResponse.allHeaderFields["Pragma"] as? String {
                if cacheControl.lowercased().contains("no-cache") {
                    debug("Pragma")
                    return
                }
            }
        }
        
        if let path = request.url?.absoluteString {
            debug("Saved cache")
            lock.writeLock()
            cache[path] = cachedResponse
        }
    }
    
    /// Удаление кэшированного запроса
    /// - Parameter request: запрос
    public override func removeCachedResponse(for request: URLRequest) {
        defer { lock.unlock() }
        
        if let path = request.url?.absoluteString {
            lock.writeLock()
            debug("removed cache for: \(path)")
            cache[path] = nil
        }
    }
    
    /// Удаление всех закэшированных запросов
    public override func removeAllCachedResponses() {
        defer { lock.unlock() }
        
        lock.writeLock()
        debug("removed all cache")
        cache.removeAll()
    }
    
    /// Сохранение кэшированного запроса
    /// - Parameters:
    ///   - cachedResponse: кэширванный запрос
    ///   - dataTask: дата таск
    public override func storeCachedResponse(_ cachedResponse: CachedURLResponse, for dataTask: URLSessionDataTask) {
        defer { lock.unlock() }
        
        if let path = dataTask.currentRequest?.url?.absoluteString {
            lock.writeLock()
            cache[path] = cachedResponse
        }
    }
    
    /// Удаление кэшированного запроса
    /// - Parameter dataTask: дата таск
    public override func removeCachedResponse(for dataTask: URLSessionDataTask) {
        defer { lock.unlock() }
        
        if let path = dataTask.currentRequest?.url?.absoluteString {
            lock.writeLock()
            cache[path] = nil
        }
    }
    
    // MARK: - Private Methods:
    
    private func debug(_ info: String) {
        #if DEBUG
        print(info)
        #endif
    }
 
}
