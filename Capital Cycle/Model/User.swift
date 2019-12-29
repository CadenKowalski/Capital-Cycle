//
//  User.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 12/8/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import Foundation
import AuthenticationServices

struct User {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    
    init(credentials: ASAuthorizationAppleIDCredential) {
        self.id = credentials.user
        self.firstName = credentials.fullName?.givenName ?? ""
        self.lastName = credentials.fullName?.familyName ?? ""
        self.email = credentials.email ?? ""
    }
}

