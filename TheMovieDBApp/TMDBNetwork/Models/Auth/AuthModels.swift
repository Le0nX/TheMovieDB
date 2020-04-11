//
//  AuthModels.swift
//  TMDBNetwork
//
//  Created by Denis Nefedov on 17.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

/// бизнес-модель request-token
public struct RequestToken: Decodable {
    
    public let success: Bool
    public let requestToken: String
    
    public init(success: Bool, requestToken: String) {
        self.success = success
        self.requestToken = requestToken
    }

}

/// бизнес-модель validate-token
public struct ValidateToken: Decodable {
    
    public let success: Bool
    public let expiresAt: String
    public let requestToken: String

}

/// бизнес-модель юзер-сессии
public struct UserSession: Decodable, Equatable {
    
    public let success: Bool
    public let sessionId: String?
    public let requestToken: String?
    
}
