//
//  APIResult.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 15.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

/// Результат работы APIClient
public enum APIResult<T> {
    case success(T)
    case failure(Error)
}