//
//  AES.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 23.04.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation
import CommonCrypto

protocol Randomizer {
    
    ///Функция возвращает рэндомный вектор инициализации.
    ///размер вектора инициализации должен быть 16 байт (128 — бит)
    static func randomIv() -> Data
    
    /// Соль
    static func randomSalt() -> Data
    
    /// Рандомные данные определенной длиины
    static func randomData(length: Int) -> Data
}

protocol Crypter {
    
    /// Зашифровать данные
    func encrypt(_ digest: Data) throws -> Data
    
    /// Расшифровать данные
    func decrypt(_ encrypted: Data) throws -> Data
}

///структура для шифрования AES
struct AESCrypter {
    
    // MARK: - Types
    
    enum CryptorError: Swift.Error {
        case keyGeneration(status: Int)
        case cryptoFailed(status: CCCryptorStatus)
        case badKeyLength
        case badInputVectorLength
    }
    
    // MARK: - Private Properties
    
    private var key: Data
    private var iv: Data
    
    // MARK: - Initializers
    
    public init(key: Data, iv: Data) throws {
        guard key.count == kCCKeySizeAES256 else {
            throw CryptorError.badKeyLength
        }
        guard iv.count == kCCBlockSizeAES128 else {
            throw CryptorError.badInputVectorLength
        }
        self.key = key
        self.iv = iv
    }
    
    // MARK: - Public Methods
    
    ///Метод для создания ключа для шифрования.
    ///Получается путем расширения пин-кода с помощью соли по алгоритму PBKDF2
    static func createKey(password: Data, salt: Data) throws -> Data {
        let length = kCCKeySizeAES256
        var status = Int32(0)
        var derivedBytes = [UInt8](repeating: 0, count: length)
        
        password.withUnsafeBytes { (passwordBytes: UnsafePointer<Int8>!) in
            salt.withUnsafeBytes { (saltBytes: UnsafePointer<UInt8>!) in
                status = CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2),
                                              passwordBytes,
                                              password.count,
                                              saltBytes,
                                              salt.count,
                                              CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
                                              10000,
                                              &derivedBytes,
                                              length)
            }
        }
        guard status == 0 else {
            throw CryptorError.keyGeneration(status: Int(status))
        }
        return Data(bytes: UnsafePointer<UInt8>(derivedBytes), count: length)
    }
    
    // MARK: - Private Methods
    
    private func crypt(input: Data, operation: CCOperation) throws -> Data {
        var outLength = Int(0)
        var outBytes = [UInt8](repeating: 0, count: input.count + kCCBlockSizeAES128)
        var status: CCCryptorStatus = CCCryptorStatus(kCCSuccess)
        input.withUnsafeBytes { (encryptedBytes: UnsafePointer<UInt8>!) -> Void in
            iv.withUnsafeBytes { (ivBytes: UnsafePointer<UInt8>!) in
                key.withUnsafeBytes { (keyBytes: UnsafePointer<UInt8>!) -> Void in
                    status = CCCrypt(operation,
                                     CCAlgorithm(kCCAlgorithmAES128),
                                     CCOptions(kCCOptionPKCS7Padding),
                                     keyBytes,
                                     key.count,
                                     ivBytes,
                                     encryptedBytes,
                                     input.count,
                                     &outBytes,
                                     outBytes.count,
                                     &outLength)
                }
            }
        }
        guard status == kCCSuccess else {
            throw CryptorError.cryptoFailed(status: status)
        }
        return Data(bytes: UnsafePointer<UInt8>(outBytes), count: outLength)
    }
    
}

extension AESCrypter: Crypter {
    
    ///Метод шифрования Data
    func encrypt(_ digest: Data) throws -> Data {
        try crypt(input: digest, operation: CCOperation(kCCEncrypt))
    }
    
    ///Метод расшифровки Data
    func decrypt(_ encrypted: Data) throws -> Data {
        try crypt(input: encrypted, operation: CCOperation(kCCDecrypt))
    }
    
}

extension AESCrypter: Randomizer {
    
    static func randomIv() -> Data {
        randomData(length: kCCBlockSizeAES128)
    }
     
    static func randomSalt() -> Data {
        randomData(length: 8)
    }
    
    static func randomData(length: Int) -> Data {
        var data = Data(count: length)
        let status = data.withUnsafeMutableBytes {
            CCRandomGenerateBytes($0, length)
        }
        assert(status == Int32(0))
        return data
    }
    
}
