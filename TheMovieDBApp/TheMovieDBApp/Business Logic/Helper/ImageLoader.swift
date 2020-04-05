//
//  ImageLoader.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 05.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

protocol ImageLoader {
    
    /// Метод запроса картинки постера фильма
    /// - Parameter for: линк постера
    /// - Parameter completion: обрработчик
    func fetchImage(for: String, completion: @escaping (Data?) -> Void) -> UUID?
}

final class ImageLoaderImp: ImageLoader {
    // MARK: - Types
    
    // MARK: - Constants
    
    // MARK: - IBOutlet
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Initializers
    
    // MARK: - UIViewController(*)
    
    // MARK: - Public methods
    
    func fetchImage(for: String, completion: @escaping (Data?) -> Void) -> UUID? {
        return nil
    }
    
    // MARK: - IBAction
    
    // MARK: - Private Methods
}
