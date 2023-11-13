//
//  User.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/24/20.
//

import Foundation
import SwiftUI

// MARK: User Struct

class User: ObservableObject {
    
    var uid = ""
    var profileImg = Image(systemName: "person.circle")
    var profileImgUrl = "Default"
    var isCounselorVerified = false
    var authenticationMethod = ""
    @Published var email = ""
    @State var type = userType.none
    @Published var isSignedIn = false
    @Published var remainSignedIn = false
    @State var prefersNotifications = true
    @State var prefersHapticFeedback = true
    @State var hasEnabledGoogleAccess = false
    @State var prefersFaceIDToAuthenticate = true
    
    // MARK: User
    
    enum userType {
        case none
        case camper
        case parent
        case counselor
        case admin
    }
    
    // MARK: Functions
    
    // Resets the users values
    func reset() {
        self.uid = ""
        self.email = ""
        self.profileImg = Image(systemName: "person.circle")
        self.profileImgUrl = "Default"
        self.isSignedIn = false
        self.remainSignedIn = false
        self.type = userType.none
        self.prefersHapticFeedback = true
        self.prefersNotifications = true
        self.isCounselorVerified = false
        self.hasEnabledGoogleAccess = false
        self.authenticationMethod = ""
        self.prefersFaceIDToAuthenticate = true
    }
}
