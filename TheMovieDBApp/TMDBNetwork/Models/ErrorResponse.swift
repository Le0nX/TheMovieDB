//
//  ErrorResponse.swift
//  TMDBNetwork
//
//  Created by Denis Nefedov on 17.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

/// DTO ошибки
public struct ErrorResponse: Decodable {
    let statusCode: Int
    let statusMessage: String
}
