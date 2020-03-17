//
//  ProfileModel.swift
//  TMDBNetwork
//
//  Created by Denis Nefedov on 17.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

public struct Profile: Decodable {
    struct Avatar: Decodable {
        let gravatar: Gravatar?
    }
    
    struct Gravatar: Decodable {
        let hash: String?
    }
    
    let avatar: Avatar?
    let id: Int?
    let name: String
    let includeAdult: Bool?
    let username: String
}
