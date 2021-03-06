//
//  FavoriteServiceModel.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 08.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

/// Модель конфигурации запроса сервиса фаворитов
struct FavoriteServiceModel {
    let sessionId: String
    let profileId: Int
    let page: Int
}

/// Модель для метода установки/удаления фаворита
struct FavoriteServiceMarkModel {
    let accountId: Int
    let sessionId: String
    let movieId: Int
    let isFavorite: Bool
}
