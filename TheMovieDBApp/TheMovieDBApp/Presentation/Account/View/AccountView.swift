//
//  AccountView.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 08.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

protocol AccountViewDelegate: class {
    
    /// Хендлер выхода из профиля
    func logout()
    
    /// Временный метод показа pincode vc
    func showPinCodeVC()
}

final class AccountView: XibView {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    // MARK: - Public Properties
    
    weak var delegate: AccountViewDelegate?
        
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
        
    // MARK: - Public methods
    
    func setup() {
        contentView.backgroundColor = ColorName.background
        setupTempPinCodeVC()
    }
    
    // MARK: - IBAction
    
    @IBAction func logoutAction(_ sender: Any) {
        delegate?.logout()
    }
    
    // MARK: - Private Methods
    
    private func setupTempPinCodeVC() {
        // TODO: - убрать
        let button = UIButton(type: .system)
        button.setTitle("PinCode", for: .normal)
        
        addSubview(button)
        button.anchor(left: leftAnchor,
                      bottom: logoutButton.topAnchor,
                      right: rightAnchor,
                      paddingLeft: 24,
                      paddingBottom: -25,
                      paddingRight: 24)
        
        button.addTarget(self, action: #selector(showPinCodeVC), for: .touchUpInside)
    }
    
    @objc private func showPinCodeVC() {
        delegate?.showPinCodeVC()
    }
}
