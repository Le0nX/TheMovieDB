//
//  APIError.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

enum APIError: Error, CustomStringConvertible {
    
    case badRequest
    case requestFailed
    case invalidData
    case notFound
    case authFailed
    case invalidApiKey
    case unknown(HTTPURLResponse?)
    case invalidService
    case invalidSessionIdResponse
    
    var description: String {
        switch self {
        case .invalidApiKey:
            return ErrorMessages.InvalidApiKey
        case .invalidService:
            return ErrorMessages.InvalidService
        case .authFailed:
            return ErrorMessages.AuthFailed
        case .notFound:
            return ErrorMessages.NotFound
        case .unknown:
            return ErrorMessages.ServerError
        case .requestFailed, .badRequest, .invalidData:
            return ErrorMessages.RequestFailed
        case .invalidSessionIdResponse:
            return errorDescription ?? ""
        }
    }
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidApiKey:
            return ErrorMessages.InvalidApiKey
        case .invalidService:
            return ErrorMessages.InvalidService
        case .authFailed:
            return ErrorMessages.AuthFailed
        case .notFound:
            return ErrorMessages.NotFound
        case .unknown:
            return ErrorMessages.ServerError
        case .requestFailed, .badRequest, .invalidData:
            return ErrorMessages.RequestFailed
        case .invalidSessionIdResponse:
            return ErrorMessages.InvalidSessionIdResponse
        }
    }
}

extension APIError {
    struct ErrorMessages {
        static let AuthFailed = NSLocalizedString("AUTH_CREDENTIALS_ERROR_MESSAGE",
                                                  comment: "Invalid Login or Password")
        static let NotFound = NSLocalizedString("AUTH_404_ERROR_MESSAGE", comment: "404. Not found.")
        static let ServerError = NSLocalizedString("AUTH_SERVER_ERROR", comment: "Server Error")
        static let RequestFailed = NSLocalizedString("AUTH_REQUEST_ERROR", comment: "Connectivity Error")
        static let InvalidService = NSLocalizedString("Invalid service: this service does not exist.",
                                                      comment: "Invalid Service")
        static let InvalidApiKey = NSLocalizedString("Invalid API key: You must be granted a valid key.",
                                                     comment: "Invalid api key")
        
        static let InvalidSessionIdResponse = NSLocalizedString("Invalid session id response",
                                                                comment: "Invalid session id response")
    }
}
