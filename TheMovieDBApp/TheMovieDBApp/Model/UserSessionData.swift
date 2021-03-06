//
//  UserMetaData.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

/// бизнес-модель пользовательских данных о текущей сессии
struct UserSessionData: Equatable {
    let token: String
    let expires: String
    let session: String
    let accountId: Int
}
