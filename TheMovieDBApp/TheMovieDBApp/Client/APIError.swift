//
//  APIError.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

enum APIError: Error, ErrorDescriptable {
    
    case badRequest
    case requestFailed
    case invalidData
    case notFound
    case authFailed
    case unknown(HTTPURLResponse?)
    
    init(response: URLResponse?) {
        guard let response = response as? HTTPURLResponse else {
            self = .unknown(nil)
            return
        }
        switch response.statusCode {
        case 400:
            self = .badRequest
        case 401:
            self = .authFailed
        case 404:
            self = .notFound
        default:
            self = .unknown(response)
        }
    }
    
    var description: String {
        switch self {
        case .authFailed:
            return ErrorMessages.AuthFailed
        case .notFound:
            return ErrorMessages.NotFound
        case .unknown:
            return ErrorMessages.ServerError
        case .requestFailed, .badRequest, .invalidData:
            return ErrorMessages.RequestFailed
        }
    }
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .authFailed:
            return ErrorMessages.AuthFailed
        case .notFound:
            return ErrorMessages.NotFound
        case .unknown:
            return ErrorMessages.ServerError
        case .requestFailed, .badRequest, .invalidData:
            return ErrorMessages.RequestFailed
        }
    }
}

extension APIError {
    struct ErrorMessages {
        static let AuthFailed = NSLocalizedString("Could't Sign In. Please check your login or password.",
                                                  comment: "Invalid Login or Password")
        static let NotFound = NSLocalizedString("404. Not found. Please, try again later.", comment: "Not found")
        static let ServerError = NSLocalizedString("Server Error. Please, try again later.", comment: "Server Error")
        static let RequestFailed = NSLocalizedString(
            "Resquest failed. Please, try again later or check your connectivity.",
            comment: "Connectivity Error")
    }
}
