//
//  ProfileModel.swift
//  TMDBNetwork
//
//  Created by Denis Nefedov on 17.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

public struct Profile: Decodable {
    public struct Avatar: Decodable {
        public let gravatar: Gravatar?
    }
    
    public struct Gravatar: Decodable {
        public let hash: String?
    }
    
    public let avatar: Avatar?
    public let id: Int?
    public let name: String
    public let includeAdult: Bool?
    public let username: String
}
