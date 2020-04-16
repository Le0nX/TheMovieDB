//
//  Reachbility.swift
//  TMDBNetwork
//
//  Created by Denis Nefedov on 16.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import Network

/// Класс проверки соединения
final class NetworkReachability {

    // MARK:- Private Properties
    
    private let pathMonitor: NWPathMonitor!
    private var path: NWPath?
    private lazy var pathUpdateHandler: ((NWPath) -> Void) = { path in self.path = path }

    private let backgroudQueue = DispatchQueue.global(qos: .background)

    // MARK: - Initializers
    
    init() {
        pathMonitor = NWPathMonitor()
        pathMonitor.pathUpdateHandler = self.pathUpdateHandler
        pathMonitor.start(queue: backgroudQueue)
    }
    
    // MARK: - Public Methods
    
    /// Проверка доступности сети
    /// - Returns: достпен/недоступен
    func isNetworkAvailable() -> Bool {
        if let path = self.path {
            if path.status == NWPath.Status.satisfied {
                return true
            }
        }
       return false
    }
}
