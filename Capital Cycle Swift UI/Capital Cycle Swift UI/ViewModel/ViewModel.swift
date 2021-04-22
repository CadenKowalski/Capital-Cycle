//
//  ViewModel.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/10/20.
//

import SwiftUI

enum PageType {
    case welcome
    case login
}

class ViewModel: ObservableObject {
    
    // MARK: Models
    
    private var overviewTabModel = OverviewTabModel()
    private var registerTabModel = RegisterTabModel()
    private var welcomePageModel = WelcomePageModel()
    private var userModel = User()
    @Published private var faqsTabModel = FAQsTabModel()
    
    // MARK: Model Variables
    
    // Sets the ViewModel's welcomeCells property to the welcomePageModel's welcomeCells property value
    var welcomeCells: [WelcomeCell] {
        welcomePageModel.welcomeCells
    }
    
    // Sets the ViewModel's overviewCells property to the overviewTabModel's overviewCells property value
    var overviewCells: [OverviewCell] {
        overviewTabModel.overviewCells
    }
    
    // Sets the ViewModel's registerCells property to the registerTabModel's registerCells property value
    var registerCells: [RegisterCell] {
        registerTabModel.registerCells
    }
    
    // Sets the ViewModel's faqCells property to the faqsTabModel's faqCells property value
    var faqCells: [FAQCell] {
        faqsTabModel.faqCells
    }
    
    // Sets the ViewModel's faqCategorySelectors property to the faqsTabModel's faqCategorySelectors property value
    var faqCategorySelectors: [FAQCategorySelector] {
        faqsTabModel.faqCategorySelectors
    }
    
    // Sets the ViewModel's currentCategory property to the faqsTabModel's currentCategory property value
    var currentCategory: FAQCategory {
        faqsTabModel.currentCategory
    }
    
    var email: String {
        get {
            userModel.email
        } set {
            changeEmail(to: newValue)
        }
    }
    
    var isCounselorVerified: Bool {
        get {
            userModel.isCounselorVerified
        } set {
            changeUserCounselorshipStatus(to: newValue)
        }
    }
    
    var type: User.userType {
        get {
            userModel.type
        } set {
            changeType(to: newValue)
        }
    }
    
    var isSignedIn: Bool {
        get {
            userModel.isSignedIn
        } set {
            changeUserSignedInStatus(status: newValue)
        }
    }
    
    var remainSignedIn: Bool {
        get {
            userModel.remainSignedIn
        } set {
            changeSignedInValue()
        }
    }
    
    /*var signUpError: [AuthenticationFunctions.signUpError] {
        AuthenticationFunctions.verifyInputs(email: "hello", password: "hello", confirmPassword: "hello", userHasAgreedToPrivacyPolicy: false)
    }*/
        
    // MARK: Intents
    
    // Calls the redirectToCampLocation function in the OverviewTabModel
    func redirectToCampLocation() {
        OverviewTabModel.redirectToCampLocation()
    }
    
    // Calls the redirectToFacebook function in the OverviewTabModel
    func redirectToFacebook() {
        overviewTabModel.redirectToFacebook()
    }
    
    // Calls the redirectToInstagram function in the OverviewTabModel
    func redirectToInstagram() {
        overviewTabModel.redirectToInstagram()
    }
    
    // Calls the switchFAQCategories function in the faqsTabModel
    func switchFAQCategories(from categorySelector: FAQCategorySelector) {
        faqsTabModel.switchCategories(from: categorySelector)
    }
    
    func changeEmail(to newEmail: String) {
        userModel.email = newEmail
    }
    
    func changeUserCounselorshipStatus(to newValue: Bool) {
        userModel.isCounselorVerified = newValue
    }
    
    func changeType(to newType: User.userType) {
        userModel.type = newType
    }
    
    func changeUserSignedInStatus(status newValue: Bool) {
        userModel.isSignedIn = newValue
    }
    
    func changeSignedInValue() {
        userModel.remainSignedIn.toggle()
    }
    
    func verifyInputs(email: String, password: String, confirmPassword: String, userHasAgreedToPrivacyPolicy: Bool) -> [AuthenticationFunctions.signUpError] {
        AuthenticationFunctions.verifyInputs(email: email, password: password, confirmPassword: confirmPassword, hasAgreedToPrivacyPolicy: userHasAgreedToPrivacyPolicy)
    }
}
