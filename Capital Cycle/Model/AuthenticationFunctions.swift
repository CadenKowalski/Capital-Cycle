//
//  AuthenticationFunctions.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 1/3/20.
//  Copyright © 2020 Caden Kowalski. All rights reserved.
//

import Foundation
import CryptoKit

struct AuthenticationFunctions {
    
    // MARK: Authentication Functions
    
    // Generates a random string of characters
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if length == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    // Encrypts a string of characters
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // Tests if a password is too weak
    func passwordIsTooWeak(password: String) -> Bool {
        var tooWeak: Bool
        var passwordContainsSymbol = false
        let letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        for letter in password {
            if !letters.contains(String(letter)) {
                passwordContainsSymbol = true
            }
        }
        
        if !passwordContainsSymbol {
            tooWeak = true
        } else if password == password.lowercased() || password == password.uppercased() {
            tooWeak = true
        } else {
            tooWeak = false
        }
        
        return tooWeak
    }
}
