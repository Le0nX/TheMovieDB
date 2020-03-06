//
//  ViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 06.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = view.center
        label.textAlignment = .center
        label.text = "RMR 2020"
        self.view.addSubview(label)
    }

}
