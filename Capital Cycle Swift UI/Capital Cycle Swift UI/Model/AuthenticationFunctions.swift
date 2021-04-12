//
//  AuthenticationFunctions.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 11/20/20.
//

import Foundation

struct AuthenticationFunctions {
    
    enum signUpError {
        case emailIsNotValid
        case passwordIsNotValid
        case passwordsDoNotMatch
        case userHasNotAgreedToPrivacyPolicy
        case none
    }

    static func verifyInputs(email: String, password: String, confirmPassword: String, hasAgreedToPrivacyPolicy: Bool) -> [signUpError] {
        
        var error = [signUpError.none]
        var passwordContainsSymbol = false
        let letters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        
        for letter in password {
            
            if !letters.contains(letter) {
                
                passwordContainsSymbol = true
            }
        }
        
        if email == "" {
            
            error.append(signUpError.emailIsNotValid)
        }
            
        if !passwordContainsSymbol {
            
            error.append(signUpError.passwordIsNotValid)
        } else if password == password.lowercased() || password == password.uppercased() {
            
            error.append(signUpError.passwordIsNotValid)
        } else if password.count < 6 {
            
            error.append(signUpError.passwordIsNotValid)
        } else if password != confirmPassword {
            
            error.append(signUpError.passwordsDoNotMatch)
        }
        
        if !hasAgreedToPrivacyPolicy {
            
            error.append(signUpError.userHasNotAgreedToPrivacyPolicy)
        }
           
        return error
    }
}
