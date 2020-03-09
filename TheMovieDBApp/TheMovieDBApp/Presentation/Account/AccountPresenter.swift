//
//  AccountPresenter.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

protocol AccountPresenterOutput {
    func didPressedLogoutButton()
}

final class AccountPresenter: AccountPresenterOutput {

    private var accountCoordinator: AccountCoordinator!
    private var credentailsService: AccessCredentialsService!
    
    init(credentailsService: AccessCredentialsService, accountCoordinator: AccountCoordinator) {
        self.credentailsService = credentailsService
        self.accountCoordinator = accountCoordinator
    }
    
    func didPressedLogoutButton() {
        try? credentailsService.delete()
        accountCoordinator.start()
    }
}
