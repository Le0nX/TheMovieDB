//
//  ApplicationAppearance.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 08.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

/// Класс настройки отображения общих частей приложения
final class ApplicationAppearance {
    
    /// Метод настройки отображения NavigationBar
    static func setupNavigatioBar() {
        UINavigationBar.appearance().barTintColor = ColorName.background
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage() // убарна линия сепаратора
    }
    
    /// Метод настройки отображения TabBar
    static func setupTabBar() {
        UITabBar.appearance().barTintColor = ColorName.buttonUnactive
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().tintColor = ColorName.buttonActive
    }
}
