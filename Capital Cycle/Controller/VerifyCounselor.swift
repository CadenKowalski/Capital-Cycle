//
//  VerifyCounselor.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 8/4/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class VerifyCounselor: UIViewController, UITextFieldDelegate, UIAdaptivePresentationControllerDelegate {

    // Storyboard outlets
    @IBOutlet weak var gradientView: CustomView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var counselorIdTxtField: UITextField!
    @IBOutlet weak var signUpBtn: CustomButton!
    @IBOutlet weak var signUpBtnProgressWheel: UIActivityIndicatorView!
    // Global code vars
    let firebaseFunctions = FirebaseFunctions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeLayout()
    }
    
    // MARK: View Setup / Management
    
    // Formats the UI
    func customizeLayout() {
        // Formats the gradient view
        if view.frame.height < 700 {
            gradientViewHeight.constant = 0.15 * view.frame.height
            gradientView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.15)
        }
        
        // Sets up the text field
        counselorIdTxtField.delegate = self
        counselorIdTxtField.attributedPlaceholder = NSAttributedString(string: "Counselor ID", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
        
        // Prevents the user from dismissing the view without deleting the account
        isModalInPresentation = true
    }
    
    // Shows an alert
    func showAlert(title: String, message: String, actionTitle: String, actionStyle: UIAlertAction.Style) {
        let Alert = UIAlertController(title: title, message:  message, preferredStyle: .alert)
        Alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
        present(Alert, animated: true, completion: nil)
        giveHapticFeedback(error: true)
    }
    
    func giveHapticFeedback(error: Bool) {
        if error {
            let feedbackGenerator = UINotificationFeedbackGenerator()
            feedbackGenerator.prepare()
            feedbackGenerator.notificationOccurred(.error)
        } else {
            let feedbackGenerator = UISelectionFeedbackGenerator()
            feedbackGenerator.selectionChanged()
        }
    }
    
    // Switches on and off the progress wheel
    func formatProgressWheel(toShow: Bool) {
        if toShow {
            self.signUpBtnProgressWheel.isHidden = false
            self.signUpBtn.alpha = 0.25
            self.signUpBtnProgressWheel.startAnimating()
        } else {
            self.signUpBtn.alpha = 1.0
            self.signUpBtnProgressWheel.stopAnimating()
        }
    }
    
    // MARK: Sign Up
    
    // Signs up the user
    @IBAction func signUp(_ sender: CustomButton) {
        formatProgressWheel(toShow: true)
        if counselorIdTxtField.text == "082404" {
            firebaseFunctions.uploadUserData() { error in
                if error == nil {
                    self.performSegue(withIdentifier: "VerifiedCounselor", sender: nil)
                    self.giveHapticFeedback(error: false)
                } else {
                    print(error!)
                }
                
                self.formatProgressWheel(toShow: true)
            }
        } else {
            counselorIdTxtField.backgroundColor = .red
            counselorIdTxtField.alpha = 0.5
            giveHapticFeedback(error: true)
            formatProgressWheel(toShow: true)
        }
    }
    
    // MARK: Dismiss
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let Alert = UIAlertController(title: nil, message: "This action will delete your account. Are you sure you want to continue?", preferredStyle: .actionSheet)
        Alert.addAction(UIAlertAction(title: "Delete my account", style: .destructive) { action in
            self.dismiss(animated: true, completion: nil)
            Auth.auth().currentUser?.delete()
        })
        
        Alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(Alert, animated: true, completion: nil)
    }
}
