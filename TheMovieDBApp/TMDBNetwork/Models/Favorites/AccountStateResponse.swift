//
//  AccountStateResponse.swift
//  TMDBNetwork
//
//  Created by Denis Nefedov on 09.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

/// DTO Account State Endpoint, говорящее о статусе фильма
/// недобходимо для проверки на принадлежность к фаворитам
public struct AccountStateResponse: Decodable {
    public let id: Int
    public let favorite: Bool
    public let watchlist: Bool
}
