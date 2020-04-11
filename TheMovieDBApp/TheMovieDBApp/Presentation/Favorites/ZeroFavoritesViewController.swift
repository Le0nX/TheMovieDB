//
//  FavoritesViewController.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 07.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

/// ViewController нулевого результата в избранном с анимацией
final class ZeroFavoritesViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let containerView: FavoritesView
    
    private lazy var emitter = CAEmitterLayer()
    
    // MARK: - Initializers
    
    init(_ view: FavoritesView = FavoritesView()) {
         self.containerView = view
         super.init(nibName: nil, bundle: nil)
     }
    
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    // MARK: - UIViewController(*)
    
    override func loadView() {
        super.loadView()
        self.view = self.containerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        DispatchQueue.global().async {
            self.emitter.emitterCells = self.generateEmitterCells()
        }
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        emitter.removeAllAnimations()
        emitter.removeFromSuperlayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        containerView.zeroView.rotateCircle()
        
        emitter.emitterPosition = CGPoint(x: self.containerView.zeroView.popCornBucket.frame.size.width / 2 - 15,
                                          y: 140)
        emitter.emitterShape = .circle
        emitter.emitterSize = CGSize(width: 50, height: 2.0)

        containerView.layer.addSublayer(emitter)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Private Methods
    
    private func generateEmitterCells() -> [CAEmitterCell] {
        var cells: [CAEmitterCell] = [CAEmitterCell]()
        for _ in 0..<5 {
            let cell = CAEmitterCell()
               
            cell.birthRate = 10.0
            cell.lifetime = 3.5
            cell.lifetimeRange = 0
            cell.velocity = CGFloat(30)
            cell.velocityRange = 0
            cell.emissionLongitude = CGFloat(Double.pi)
            cell.emissionRange = 0.5
            cell.xAcceleration = 15
            cell.yAcceleration = 20
            cell.spin = 3.5
            cell.spinRange = 0
            cell.contents = ImageName.popCorn.cgImage
            cell.scaleRange = 0.25
            cell.scale = 0.3
               
            cells.append(cell)
        }
           return cells
       }
}
