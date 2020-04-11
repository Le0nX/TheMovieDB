//
//  Profile.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 17.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

/// бизнес-модель профиля 
struct Profile: Equatable {
    let id: Int
    let name: String
    let username: String
    let image: Data
}
