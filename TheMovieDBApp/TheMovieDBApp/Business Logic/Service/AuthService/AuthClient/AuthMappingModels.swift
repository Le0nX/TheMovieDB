//
//  AuthServiceResult.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

struct RequestToken: Decodable {
    
    let success: Bool
    let expiresAt: String
    let requestToken: String

}

struct UserSession: Decodable {
    
    let success: Bool
    let sessionId: String?
    
}
