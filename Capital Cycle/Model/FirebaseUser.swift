//
//  FirebaseUser.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 12/28/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit

struct FirebaseUser {
    var email: String?
    var password: String?
    var profileImg: UIImage?
    var profileImgUrl: String?
    var signedIn: Bool?
    var type: type?
    var prefersHapticFeedback: Bool?
    var prefersNotifications: Bool?
    
    enum type {
        case none
        case camper
        case parent
        case counselor
        case admin
    }
}
