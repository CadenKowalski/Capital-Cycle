//
//  Firebase.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 12/28/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import Firebase

class FirebaseFunctions {
    
    // Creates a Firebase user via the email provider
    func createUser(email: String, password: String, completion: @escaping() -> Void) {
        Auth.auth().createUser(withEmail: email, password: password)
        Auth.auth().currentUser?.sendEmailVerification(completion: nil)
        completion()
    }
}
