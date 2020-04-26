//
//  JailbreakDetector.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 23.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import UIKit

/// Класс детектирования джейлбрейка на основе самых популярных способов
final class JaibreakDetector {
    
    public static func jailbroken() -> Bool {
        guard let cydiaUrlScheme = NSURL(string: "cydia://package/com.example.package") else { return isJailbroken() }
        return UIApplication.shared.canOpenURL(cydiaUrlScheme as URL) || isJailbroken()
    }
    
    static private func isJailbroken() -> Bool {
        
        if TARGET_IPHONE_SIMULATOR != 0 {
            return false
        }
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: "/Applications/Cydia.app") ||
            fileManager.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") ||
            fileManager.fileExists(atPath: "/bin/bash") ||
            fileManager.fileExists(atPath: "/usr/sbin/sshd") ||
            fileManager.fileExists(atPath: "/etc/apt") ||
            fileManager.fileExists(atPath: "/usr/bin/ssh") {
            return true
        }
        
        if canOpen(path: "/Applications/Cydia.app") ||
            canOpen(path: "/Library/MobileSubstrate/MobileSubstrate.dylib") ||
            canOpen(path: "/bin/bash") ||
            canOpen(path: "/usr/sbin/sshd") ||
            canOpen(path: "/etc/apt") ||
            canOpen(path: "/usr/bin/ssh") {
            return true
        }
        
        let path = "/private/" + NSUUID().uuidString
        do {
            try "Jailbreak".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            try fileManager.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    
    static private func canOpen(path: String) -> Bool {
        let file = fopen(path, "r")
        guard file != nil else { return false }
        fclose(file)
        return true
    }
}
