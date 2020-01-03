//
//  VerifyCounselor.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 8/4/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import Firebase

class VerifyCounselor: UIViewController, UITextFieldDelegate {
    
    // MARK: Global Variables
    
    // Storyboard outlets
    @IBOutlet weak var gradientView: CustomView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var counselorIdTxtField: UITextField!
    @IBOutlet weak var signUpBtn: CustomButton!
    @IBOutlet weak var signUpBtnProgressWheel: UIActivityIndicatorView!
    // Code global vars
    var password: String!
    
    // MARK: View Instantiation
    
    // Runs when the view is loaded for the first time
    override func viewDidLoad() {
        super.viewDidLoad()
        formatUI()
    }
    
    // MARK: View Formatting
    
    // Formats the UI
    func formatUI() {
        // Formats the gradient view
        if view.frame.height < 700 {
            gradientViewHeight.constant = 0.15 * view.frame.height
            gradientView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.15)
        }
        
        // Formats the text field
        counselorIdTxtField.delegate = self
        counselorIdTxtField.attributedPlaceholder = NSAttributedString(string: "Counselor ID", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
    }
    
    // MARK: Sign Up
    
    // Signs up the user
    @IBAction func signUp(_ sender: CustomButton) {
        viewFunctions.formatProgressWheel(progressWheel: signUpBtnProgressWheel, button: signUpBtn, toShow: true)
        if counselorIdTxtField.text == "082404" {
            user.isCounselorVerified = true
            firebaseFunctions.createUser(password: password) { error in
                if error == nil {
                    firebaseFunctions.uploadUserData() { error in
                        if error == nil {
                            self.performSegue(withIdentifier: "VerifiedCounselor", sender: nil)
                        } else {
                            viewFunctions.showAlert(title: "Error", message: error!, actionTitle: "OK", actionStyle: .default, view: self)
                        }
                        
                        viewFunctions.formatProgressWheel(progressWheel: self.signUpBtnProgressWheel, button: self.signUpBtn, toShow: false)
                    }
                } else {
                    viewFunctions.showAlert(title: "Error", message: error!, actionTitle: "OK", actionStyle: .default, view: self)
                    viewFunctions.formatProgressWheel(progressWheel: self.signUpBtnProgressWheel, button: self.signUpBtn, toShow: false)
                }
            }
        } else {
            counselorIdTxtField.backgroundColor = .red
            counselorIdTxtField.alpha = 0.5
            viewFunctions.formatProgressWheel(progressWheel: signUpBtnProgressWheel, button: signUpBtn, toShow: false)
        }
    }
}
