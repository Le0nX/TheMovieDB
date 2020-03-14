//
//  Coordinator.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 08.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

/// Класс Координатора отвечает за навигацию между экранами,
/// снимая эту ответственность UIViewController класса
protocol Coordinator: class {
    
    /// Метод запуска перехода на следующий экран
    /// в зависимости от настроенного в реализации
    /// протокола флоу переходов
    func start()
}
