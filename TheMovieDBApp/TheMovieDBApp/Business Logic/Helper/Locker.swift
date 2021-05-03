//
//  Locker.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 23.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import UIKit

/// Блокировщик экрана
final class Locker {
    
    // MARK: - Private Properties
    
    private let storyAssembler: StoriesAssembler
    private let accessService: AccessCredentialsService
    
    private var shouldLogin = false
    
    private var task: DispatchWorkItem?
    
    // MARK: - Initializers
    
    init(storyAssembler: StoriesAssembler,
         accessService: AccessCredentialsService) {
        self.storyAssembler = storyAssembler
        self.accessService = accessService
    }
    
    // MARK: - Public Methods
    
    /// Метод проверки необходимости залочить экран пинкодом
    func shouldPinCode() {
        task?.cancel()
        if shouldLogin, accessService.pinCode != nil {
            UIApplication.setRootView(storyAssembler.makePinCodeStory(with: .lock(image: ImageName.faceId)))
            shouldLogin = false
        }
    }
    
    /// Метод запуска бэкграунд таски, которая выставит флаг блокировки по истечении 2х мин
    func lock() {
        if accessService.sessionIsValid() {
            task = DispatchWorkItem {
                self.shouldLogin = true
            }
            DispatchQueue.global(qos: .background).asyncAfter(deadline: DispatchTime.now() + 2 * 60, execute: task!)
        }
    }
}
