//
//  MarkAsFavoriteResponse.swift
//  TMDBNetwork
//
//  Created by Denis Nefedov on 07.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

/// DTO MarkAsFavoriteEndpoint'a
public struct MarkAsFavoriteResponse: Decodable {
    let statusCode: Int
    let statusMessage: String
}
