//
//  ErrorResponse.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 16.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

struct ErrorResponse: Decodable {
    let statusCode: Int
    let statusMessage: String
}
