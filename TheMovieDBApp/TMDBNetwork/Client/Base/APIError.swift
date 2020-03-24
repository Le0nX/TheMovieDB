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
            return errorDescription ?? ""
        case .invalidService:
            return errorDescription ?? ""
        case .authFailed:
            return errorDescription ?? ""
        case .notFound:
            return errorDescription ?? ""
        case .unknown:
            return errorDescription ?? ""
        case .requestFailed, .badRequest, .invalidData:
            return errorDescription ?? ""
        case .invalidSessionIdResponse:
            return errorDescription ?? ""
        }
    }
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidApiKey:
            return NSLocalizedString("Invalid API key: You must be granted a valid key.", comment: "Invalid api key")
        case .invalidService:
            return NSLocalizedString("Invalid service: this service does not exist.", comment: "Invalid Service")
        case .authFailed:
            return NSLocalizedString("AUTH_CREDENTIALS_ERROR_MESSAGE", comment: "Invalid Login or Password")
        case .notFound:
            return NSLocalizedString("AUTH_404_ERROR_MESSAGE", comment: "404. Not found.")
        case .unknown:
            return  NSLocalizedString("AUTH_SERVER_ERROR", comment: "Server Error")
        case .requestFailed, .badRequest, .invalidData:
            return NSLocalizedString("AUTH_REQUEST_ERROR", comment: "Connectivity Error")
        case .invalidSessionIdResponse:
            return NSLocalizedString("Invalid session id response", comment: "Invalid session id response")
        }
    }
}
