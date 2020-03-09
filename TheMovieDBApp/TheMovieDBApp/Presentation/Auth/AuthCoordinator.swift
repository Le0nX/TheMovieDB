//
//  AuthCoordinator.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

final class AuthCoordinator: Coordinator {
    private var  storyAssembler: StorysAssembler!
    
    init(storyAssembler: StorysAssembler) {
        self.storyAssembler = storyAssembler
    }
    
    private func login() {
        UIApplication.setRootView(UINavigationController(rootViewController: storyAssembler.makeTabBar()))
    }
    
    func start() {
        login()
    }
}
