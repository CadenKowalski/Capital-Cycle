//
//  FirebaseUser.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 12/28/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit

struct FirebaseUser {
    
    // MARK: Global Variables
    
    // Code global vars
    var uid: String!
    var email: String!
    var profileImg: UIImage!
    var profileImgUrl: String!
    var signedIn: Bool!
    var type: type!
    var prefersHapticFeedback: Bool!
    var prefersNotifications: Bool!
    var isCounselorVerified: Bool!
    var isGoogleVerified: Bool!
    var authenticationMethod: String!
    var useFaceIDForAuthentication: Bool!
    
    // MARK: User
    
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
        self.profileImg = UIImage(systemName: "person.circle")
        self.profileImgUrl = "Default"
        self.signedIn = false
        self.type = FirebaseUser.type.none
        self.prefersHapticFeedback = true
        self.prefersNotifications = true
        self.isCounselorVerified = false
        self.isGoogleVerified = false
        self.authenticationMethod = ""
        self.useFaceIDForAuthentication = true
    }
}
