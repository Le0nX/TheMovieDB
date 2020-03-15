//
//  AuthCoordinator.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

/// Координатор экрана Auth
final class AuthCoordinator: Coordinator {
    
    // MARK: - Private Properties

    private var  storyAssembler: StoriesAssembler

    // MARK: - Initializers
    
    init(storyAssembler: StoriesAssembler) {
        self.storyAssembler = storyAssembler
    }
        
    // MARK: - Public methods
        
    func start() {
        login()
    }
    
    // MARK: - Private Methods
    
    private func login() {
        UIApplication.setRootView(UINavigationController(rootViewController: storyAssembler.makeTabBar()))
    }
}
