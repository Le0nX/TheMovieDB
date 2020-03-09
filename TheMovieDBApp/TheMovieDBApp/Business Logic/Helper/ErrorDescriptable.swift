//
//  ErrorDescriptable.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

protocol Descriptable {
    
    var description: String { get }
    
}

protocol ErrorDescriptable: Descriptable {}
