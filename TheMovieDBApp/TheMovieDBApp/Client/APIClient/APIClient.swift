//
//  HTTPClient.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

protocol APIClient: AnyObject {
    
    /// Дженерик метод запроса по сети
    ///
    /// - Parameter endpoint: ендпоинт, куда делаем запрос
    /// - Parameter completionHandler: обработчик декодированного ответа на основе дженерик результата
    ///
    /// - Returns:возвращате Progress запроса.
    @discardableResult
    func request<T>(
        _ endpoint: T,
        completionHandler: @escaping (APIResult<T.Content>) -> Void
    ) -> Progress where T: Endpoint
}
