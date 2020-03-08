//
//  AccountView.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 08.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

protocol AccountViewOutput {
    
    /// Хендлер выхода из профиля
    func logout()
}

final class AccountView: XibView {
    // MARK: - Outlets
    @IBOutlet weak var logoutButton: UIButton!
    
    // MARK: - public fields
    var output: AccountViewOutput!
    
    // MARK: - constructors
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - View setupers
    func setup() {
        contentView.backgroundColor = ColorName.background
    }
    
    // MARK: - IBActions
    @IBAction func logoutAction(_ sender: Any) {
        output.logout()
    }
}
