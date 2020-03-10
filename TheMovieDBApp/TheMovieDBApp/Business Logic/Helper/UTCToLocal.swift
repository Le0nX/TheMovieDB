//
//  UTCToLocal.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

/// Вспомогательный метод перевода времени из строки в Date
/// - Parameter date: время в формате "yyyy-MM-dd HH:mm:ss Z"
func toDate(date: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

    guard let dt = dateFormatter.date(from: date) else { return Date() }
    return dt
}
