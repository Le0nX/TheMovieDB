//
//  ZeroFavoritesView.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

/// Экран нулевого результата в избранном
final class ZeroFavoritesView: XibView {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var cocaColla: UIImageView!
    @IBOutlet private var circleMovable: UIImageView!
    @IBOutlet var popCornBucket: UIImageView!
    @IBOutlet private var tubeImage: UIImageView!
    
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
        backgroundColor = ColorName.background
    }
    
    func rotateCircle() {
        rotate(for: circleMovable.layer, duration: 12)
    }

    private func rotate(for layer: CALayer, duration: Double = 1) {
        if layer.animation(forKey: "rotationanimationkey") == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")

            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity

            layer.add(rotationAnimation, forKey: "rotationanimationkey")
        }
    }
}
