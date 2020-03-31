//
//  WeakRef.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 18.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
// Моя статья на тему этого паттерна: https://medium.com/you-gotta-get-schwifty/memory-management-arc-done-right-%D1%81-%D1%81%D0%BE%D1%85%D1%80%D0%B0%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5%D0%BC-clean-%D0%B0%D1%80%D1%85%D0%B8%D1%82%D0%B5%D0%BA%D1%82%D1%83%D1%80%D1%8B-76a676d8ee79

final class WeakRef<T: AnyObject> {
    weak var ref: T?

    init (_ object: T) {
        self.ref = object
    }
}

extension WeakRef: AccountViewInput where T: AccountViewInput {
    func setRemoteProfileData(profile: Profile) {
        ref?.setRemoteProfileData(profile: profile)
    }
    
    func showProgress() {
        ref?.showProgress()
    }
    
    func hideProgress() {
        ref?.hideProgress()
    }
}

extension WeakRef: AuthViewInput where T: AuthViewInput {
    func showError(with error: String) {
        ref?.showError(with: error)
    }
    
    func showProgress() {
        ref?.showProgress()
    }
    
    func hideProgress() {
        ref?.hideProgress()
    }
}

extension WeakRef: SearchViewInput where T: SearchViewInput {
    func setMoviesData(movies: [MovieEntity]) {
        ref?.setMoviesData(movies: movies)
    }
    
    func showError(error: Error) {
        ref?.showError(error: error)
    }
}
