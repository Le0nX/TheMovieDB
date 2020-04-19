//
//  DAOErrors.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 14.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

enum DAOError: Error {
    
    case sqlDataBaseCreation
}

extension DAOError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .sqlDataBaseCreation:
            return NSLocalizedString("Could't create sql lite 3 DB", comment: "")
        }
    }
}
