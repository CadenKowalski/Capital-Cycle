//
//  FirebaseUser.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 12/28/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit

struct FirebaseUser {
    var uid: String!
    var email: String!
    var password: String?
    var profileImg: UIImage!
    var profileImgUrl: String!
    var signedIn: Bool!
    var type: type!
    var prefersHapticFeedback: Bool!
    var prefersNotifications: Bool!
    
    enum type {
        case none
        case camper
        case parent
        case counselor
        case admin
    }
    
    mutating func reset() {
        self.uid = ""
        self.email = ""
        self.password = ""
        self.profileImg = UIImage(systemName: "person.circle")
        self.profileImgUrl = "Default"
        self.signedIn = false
        self.type = FirebaseUser.type.none
        self.prefersHapticFeedback = true
        self.prefersNotifications = true
    }
}
