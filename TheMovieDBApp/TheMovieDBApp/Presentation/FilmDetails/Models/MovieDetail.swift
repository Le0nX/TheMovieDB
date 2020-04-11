//
//  MovieDetail.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 05.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import UIKit

/// Бизнес-модель деталей фильма
struct MovieDetail {
    let movieName: String?
    let genre: String?
    let movieOriginalName: String?
    let popularity: String?
    let votes: String?
    let poster: UIImage?
    
    let overview: String?
    
    let movieId: Int
}
