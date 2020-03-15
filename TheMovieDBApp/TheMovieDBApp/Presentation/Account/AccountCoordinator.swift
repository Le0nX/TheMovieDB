//
//  AccountCoordinator.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

/// Координатор экрана профиля
final class AccountCoordinator: Coordinator {
    
    // MARK: - Private Properties
    
    private var  storyAssembler: StoriesAssembler
    
    // MARK: - Initializers
    
    init(storyAssembler: StoriesAssembler) {
        self.storyAssembler = storyAssembler
    }
        
    // MARK: - Public methods
    
    func start() {
        logout()
    }
        
    // MARK: - Private Methods
    
    private func logout() {
        UIApplication.setRootView(UINavigationController(rootViewController: storyAssembler.makeAuthStory()))
    }
}
