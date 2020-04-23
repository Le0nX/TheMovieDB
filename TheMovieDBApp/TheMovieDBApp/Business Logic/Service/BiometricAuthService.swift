//
//  BiometricAuthService.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 23.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import LocalAuthentication

enum BiometricAuthenticationType {
    case faceId
    case touchId
    case unavailable
    
    var img: String {
        String(describing: self)
    }
}

protocol BioMetricAuthenticatorService {
    
    func getBiometricAuthenticationType() -> BiometricAuthenticationType
    func authenticate(completion: @escaping (Bool) -> Void)
}

class BioMetricAuthenticatorServiceImp: BioMetricAuthenticatorService {
    
    private lazy var context: LAContext! = {
        let context = LAContext()
        if #available(iOS 11.0, *) {
            context.localizedCancelTitle = "Отмена"
            context.localizedFallbackTitle = "Вернуться"
            switch context.biometryType {
            case .faceID, .touchID:
                context.localizedReason = "Разблокировка с использованием Touch / Face ID"
            case .none:
                context.localizedReason = "None"
            default:
                break
            }
        }
        return context
    }()
    
    func getBiometricAuthenticationType() -> BiometricAuthenticationType {
        var isBiometricAuthenticationAvailable = false
        var error: NSError?
        
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            isBiometricAuthenticationAvailable = (error == nil)
        }
        
        if !isBiometricAuthenticationAvailable {
            return .unavailable
        }
        
        if #available(iOS 11.0, *) {
            if context.biometryType == .touchID {
                return .touchId
            } else if context.biometryType == .faceID {
                return .faceId
            } else {
                return .unavailable
            }
        } else {
            return .touchId
        }
    }
    
    func authenticate(completion: @escaping (Bool) -> Void) {
        var authError: NSError?
        if #available(iOS 8.0, *) {
            if context.canEvaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                error: &authError) {
                
                context.evaluatePolicy(
                    .deviceOwnerAuthenticationWithBiometrics,
                    localizedReason: "Разблокировка с использованием Touch / Face ID") { success, error in
                    
                    DispatchQueue.main.async {
                        if error == nil {
                            completion(success)
                        } else {
                            completion(false)
                        }
                    }
                }
            } else {
                completion(false)
            }
        } else {
            completion(false)
        }
    }
}
