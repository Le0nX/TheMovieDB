//
//  APIError.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

enum APIError: Error, ErrorDescriptable {
    
    case networkProblem
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
        case .networkProblem, .unknown:
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
        case .networkProblem, .unknown:
            return ErrorMessages.ServerError
        case .requestFailed, .badRequest, .invalidData:
            return ErrorMessages.RequestFailed
        }
    }
}

extension APIError {
    struct ErrorMessages {
        static let AuthFailed = "Could't Sign In. Please check your login or password."
        static let NotFound = "404. Not found. Please, try again later."
        static let ServerError = "Server Error. Please, try again later."
        static let RequestFailed = "Resquest failed. Please, try again later or check your connectivity."
    }
}
