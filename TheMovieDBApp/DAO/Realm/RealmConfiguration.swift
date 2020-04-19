//
//  RealmConfiguration.swift
//  DAO
//
//  Created by Denis Nefedov on 15.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import RealmSwift

/// Конфигурация RealmDAO
public struct RealmConfiguration {
    
    // MARK: - Public Properties
    
    /// Имя бд
    public let databaseFileName: String
    
    /// Ссылка на бд
    public let databaseURL: URL?
    
    // MARK: - Initializers
    
    public init(databaseFileName: String = "myDb.realm",
                databaseURL: URL? = nil) {
        
        self.databaseFileName = databaseFileName
        self.databaseURL = databaseURL
    }
    
    // MARK: - Public Methods
    
    public func makeRealmConfiguration() -> Realm.Configuration {
        
        var config = Realm.Configuration.defaultConfiguration
        
        guard let path = self.databaseURL ?? pathForFileName(self.databaseFileName) else {
            fatalError("Cant find path for DB with filename: \(self.databaseFileName)")
        }
        config.fileURL = path
        
        return config
    }
    
    private func pathForFileName(_ fileName: String) -> URL? {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true).first as NSString?
        
        guard let realmPath = documentDirectory?.appendingPathComponent(fileName) else {
            return nil
        }
        return URL(string: realmPath)
    }
}
