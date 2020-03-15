//
//  TextField+isEmpty.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 06.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

extension UITextField {
    var isEmpty: Bool {
        text?.isEmpty ?? true
    }
}
