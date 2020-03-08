//
//  AccountView.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 08.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

protocol AccountViewOutput {
    func logout()
}

final class AccountView: XibView {
    var output: AccountViewOutput!
    @IBOutlet weak var logoutButton: UIButton!
    
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
    @IBAction func logoutAction(_ sender: Any) {
        output.logout()
    }
}
