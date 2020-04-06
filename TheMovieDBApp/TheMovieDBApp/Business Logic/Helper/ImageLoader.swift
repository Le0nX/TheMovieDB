//
//  ImageLoader.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 05.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import TMDBNetwork

protocol ImageLoader {
    
    /// Метод запроса картинки постера фильма
    /// - Parameter for: линк постера
    /// - Parameter completion: обрработчик
    func fetchImage(for: String, completion: @escaping (Data?) -> Void) -> UUID?
    
    /// Метод удаления таска из пула запущенных тасков, после того как постер был загружен
    /// - Parameter poster: часть url постера без baseUrl
    func cancelTask(for poster: UUID)
}

/// Класс загрузки картинок с кэшированием и хранением текущих тасков
final class TMDBImageLoader: ImageLoader {
    
    // MARK: - Private Properties
    
    private let client: APIClient
    
    private let simpleCache = NSCache<NSString, NSData>()
    private var runningTasks: [UUID: Progress] = [:]
    
    // MARK: - Initializers
    
    init(_ client: APIClient) {
        self.client = client
    }
        
    // MARK: - Public methods
    
    func fetchImage(for poster: String, completion: @escaping (Data?) -> Void) -> UUID? {
        /// проверяем наличие кэша. Если есть, то завершаемся с ним
        if let cachedVersion = simpleCache.object(forKey: NSString(string: poster)) {
            completion(cachedVersion as Data)
            return nil
        }
        
        let endpoint = PosterEndpoint(poster: poster)
        let posterTaskUUID = UUID()
        
        runningTasks[posterTaskUUID] = client.request(endpoint) { [weak self] result in
            defer { self?.runningTasks.removeValue(forKey: posterTaskUUID) } // таска завершилась
            
            switch result {
            case .success(let posterData):
                
                self?.simpleCache.setObject(posterData as NSData, forKey: NSString(string: poster))
                completion(posterData)
                    
            case .failure:
                completion(nil)
            }
            
        }
        
        return posterTaskUUID
    }
    
    func cancelTask(for poster: UUID) {
        if let task = runningTasks[poster] {
            task.cancel()
            runningTasks.removeValue(forKey: poster)
        }
    }
}
