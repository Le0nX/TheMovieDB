//
//  PinCodeView.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 07.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import UIKit

protocol PinCodeViewDelegate: class {
    func update(state: MainPinCodeViewController.State)
        
    func pinCodeDidUnlock(with pin: String, _ view: PinCodeView)
    
    func biometryDidUnlock()
    
    func pinCodeDidSet(with pin: String)
    
    func bioAuth(completion: @escaping (Bool) -> Void)
    
    func exit()
}

/// Класс отображения экрана PinCode
final class PinCodeView: XibView {

    // MARK: - IBOutlet
    @IBOutlet private var pinIndicators: [PinIndicator]!
    @IBOutlet private var pinStack: UIStackView!
    @IBOutlet private var errorLabel: UILabel!
    @IBOutlet private var rightButton: UIButton!
    @IBOutlet private var leftButton: UIButton!
    @IBOutlet private var indicatorsCenterX: NSLayoutConstraint!
    
    // MARK: - Public Properties
    
    weak var delegate: PinCodeViewDelegate?
    
    // MARK: - Private Properties
    
    private var pinPress = ""
    
    /// копия пина
    private var pin: String = "" {
        didSet {
            print("Current pin \(pin)")
        }
    }
    var state: MainPinCodeViewController.State = .lock(image: ImageName.faceId) {
        didSet {
            render()
        }
    }
        
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    @IBAction func pressButton(_ sender: KeyboardButton) {
        guard let pin = sender.titleLabel?.text,
                        pinPress.count < pinIndicators.count else {
            return
        }
        if !errorLabel.isHidden {
           hideError()
        }

        sender.pressButton()
        pinPress += pin
        
        pinIndicators[pinPress.count - 1].animateFilling()
        processPin()
        
    }
    
    @IBAction func removeDigit(_ sender: Any) {
        switch state {
        case .lock(let img):
            if img == ImageName.faceId {
                delegate?.bioAuth { result in
                    if result {
                        self.pinIndicators.forEach { $0.animateFilling() }
                        self.delegate?.biometryDidUnlock()
                    } else {
                        // TODO: - нету биометриии
                    }
                }
                print("faceid")
                break
            } else {
                remove()
            }
        default:
            remove()
        }
        
    }
    
    @IBAction func leftButtonAction(_ sender: Any) {
        delegate?.exit()
    }
    
    private func remove() {
        if pinPress.isEmpty {
            return
        }
        
        pinPress.removeLast()
        pinIndicators[pinPress.count].animateResetFilling()
    }
    
    // MARK: - Public Methods
    
    func fail() {
        indicateError()
        pinPress = ""
    }
    
    // MARK: - Private Mthods
    
    private func render() {
        switch state {
        case .setup(let step):
            leftButton.isEnabled = false
            leftButton.alpha = 0
            rightButton.setImage(ImageName.backSpace, for: .normal)
            delegate?.update(state: .setup(stage: 1))
            if step == 2 {
                hideError()
                animateFadedInOut()
                delegate?.update(state: .setup(stage: 2))
            }
        case .lock(let img):
            if let img = img {
                rightButton.setImage(img, for: .normal)
            }
            leftButton.isEnabled = true
            leftButton.alpha = 1
            delegate?.update(state: state)
        }
    }
    
    private func animateFadedInOut() {
        self.indicatorsCenterX.constant = -1000
        UIView.animate(withDuration: 0.35, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            self.indicatorsCenterX.constant = 0
            self.layoutIfNeeded()
        })
    }
    
    private func setup() {
        backgroundColor = ColorName.background
    }
    
    private func startAgain() {
        state = .setup(stage: 1)
        hideError()
    }
    
    private func indicateError() {
        shakeAllIndicators()
        pinIndicators.forEach { $0.makeRed() }
        errorLabel.isHidden = false
        state = .lock(image: ImageName.faceId)
    }
    
    private func hideError() {
        errorLabel.isHidden = true
        pinIndicators.forEach { $0.animateResetFilling() }
    }
    
    private func processPin() {
        if pinPress.count == 4 {
            switch state {
            case .lock:
//                let passcode = delegate?.getPinCode()
//                if passcode == pinPress {
//                    print("unlocked")
                    delegate?.pinCodeDidUnlock(with: pinPress, self)
//                } else {
//                    print("fail to unlock")
//                    indicateError()
//                    pinPress = ""
                    // TODO: - счетчик ошибок
//                    failUnclockCount += 1
//                    if failUnclockCount == 3 {
//                        output.pinCodeViewDidFailUnlock(self)
//                    }
//                }
            case .setup(let step) where  step == 1:
                pin = pinPress
                pinPress = ""
                state = .setup(stage: 2)
                print("step 1 end")
            case .setup(let step) where  step == 2:
                if pinPress != pin {
                    pinPress = ""
                    indicateError()
                    startAgain()
                } else {
                    print("setuped")
                    delegate?.pinCodeDidSet(with: pinPress)
                }
            default:
                break
            }
        }
    }
    
    private func shakeAllIndicators() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        pinStack?.layer.add(animation, forKey: "shake")
    }
}
