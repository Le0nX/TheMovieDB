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
    let expiersAt: String
    let token: String
    
    private enum CodingKeys: String, CodingKey {
        case success
        case expiersAt = "expires_at"
        case token = "request_token"
    }
}

struct UserSession: Decodable {
    
    let success: Bool
    let sessionId: String?
    
    private enum CodingKeys: String, CodingKey {
        case success
        case sessionId = "session_id"
    }
}
