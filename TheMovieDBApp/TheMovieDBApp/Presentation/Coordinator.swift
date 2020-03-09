//
//  Coordinator.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 08.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

/**
 Класс Координатора отвечает за навигацию между экранами,
 снимая эту ответственность UIViewController класса
 */
protocol Coordinator: class {
    
    /// дочерние координаторы
    var childCoordinators: [Coordinator] { get }
    
    /// Метод добавления координатора в пул дочерних координаторов
    /// - Parameter coordinator: координатор, который необходимо добавить
    func add(childCoordinator coordinator: Coordinator)
    
    /// Метод удаления координатора из пула дочерних координаторов
    /// - Parameter coordinator: координатор, который необходимо удалить
    func remove(childCoordinator coordinator: Coordinator)

    /**
     Метод запуска координатора.
     Выполняет логику настройки и мененджмента своего UIViewController'a.
     Должен быть вызван только один раз за весь lifetime координатора.
     Вызов данного метода более чем 1 раз вызывает forced fatalError.
     Должен вызывать super.
     */
    func start()
}
