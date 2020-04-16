//
//  SettingsService.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 16.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

protocol SettingsService {
    
    /// Метод проверки текущей конфигурации БД
    static func checkDataBaseSettings() -> AppSettings.DataBaseType
}

/// Сервис настроек приложения
final public class AppSettings: SettingsService {
    
    // MARK: - Types
    
    enum DataBaseType {
        case realm
        case coreData
    }
    
    // MARK: - Constatnts
    
    static private let dbSettingsKey = "REALM_IS_SELECTED"
    
    // MARK: - Public methods
    
    static func checkDataBaseSettings() -> DataBaseType {
        if UserDefaults.standard.bool(forKey: dbSettingsKey) {
            return .realm
        } else {
            return .coreData
        }
    }
}
