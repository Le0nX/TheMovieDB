//
//  DataConverter.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 04.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import UIKit

/// Конвертер данных в различные форматы.
/// Создан с целью вынести ответственность за конвертацию generic данных в
/// UI формат.
final class DataConverter {
    
    // MARK: - Public methods
    
    /// Конвертер из Data в Image
    /// - Parameter data: данные картинки
    static func toImage(from data: Data) -> UIImage? {
        UIImage(data: data)
    }
}
