//
//  SingInWithAppleButton.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/10/20.
//

import SwiftUI
import AuthenticationServices

// MARK: SignInWithAppleButton Struct

struct SignInWithAppleButton: UIViewRepresentable {
    
    var cornerRadius: CGFloat!
    var buttonStyle: ASAuthorizationAppleIDButton.ButtonType!
    
    // Returns the Sign In With Apple view
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let signInWithAppleButton = ASAuthorizationAppleIDButton(authorizationButtonType: buttonStyle, authorizationButtonStyle: .white)
        signInWithAppleButton.cornerRadius = cornerRadius
        return signInWithAppleButton
    }
    
    // Updates the Sign In With Apple view
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
    }
}
