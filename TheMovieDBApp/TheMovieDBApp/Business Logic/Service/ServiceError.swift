//
//  ServiceError.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 23.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

enum ServiceError: Error, CustomStringConvertible {
    
    case invalidSessionIdResponse
    
    var description: String {
        switch self {
        case .invalidSessionIdResponse:
            return errorDescription ?? ""
        }
    }
}

extension ServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidSessionIdResponse:
            return NSLocalizedString("Invalid session id response", comment: "Invalid session id response")
        }
    }
}
