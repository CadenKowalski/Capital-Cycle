//
//  VerifyUser.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 8/4/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class VerifyUser: UIViewController, UIAdaptivePresentationControllerDelegate {

    // Storyboard outlets
    @IBOutlet weak var gradientView: CustomView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var refreshBtn: UIButton!
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
    
    // Initiates haptic feedback
    func giveHapticFeedback(error: Bool) {
        if user.prefersHapticFeedback! {
            if error {
                let feedbackGenerator = UINotificationFeedbackGenerator()
                feedbackGenerator.prepare()
                feedbackGenerator.notificationOccurred(.error)
            } else {
                let feedbackGenerator = UISelectionFeedbackGenerator()
                feedbackGenerator.selectionChanged()
            }
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
    
    // Checks if the user has verified their email
    @IBAction func checkForVerifiedUser(_ sender: UIButton) {
        Auth.auth().currentUser?.reload(completion: { Action in
            if Auth.auth().currentUser!.isEmailVerified {
                self.refreshBtn.isHidden = true
                self.signUpBtn.isHidden = false
            } else {
                self.showAlert(title: "Uh oh", message: "It looks like you haven't verified your email yet", actionTitle: "OK", actionStyle: .default)
            }
        })
    }
    
    // Signs up the user
    @IBAction func signUp(_ sender: CustomButton) {
        self.formatProgressWheel(toShow: true)
        giveHapticFeedback(error: false)
        firebaseFunctions.uploadUserData() { error in
            if error == nil {
                self.performSegue(withIdentifier: "verifiedUser", sender: nil)
                self.formatProgressWheel(toShow: false)
            } else {
                print("Could not upload user information")
                self.formatProgressWheel(toShow: false)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Dismiss
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        print(true)
        let Alert = UIAlertController(title: nil, message: "This action will delete your account. Are you sure you want to continue?", preferredStyle: .actionSheet)
        Alert.addAction(UIAlertAction(title: "Delete my account", style: .destructive) { action in
            self.dismiss(animated: true, completion: nil)
            Auth.auth().currentUser?.delete()
        })
        
        Alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(Alert, animated: true, completion: nil)
    }
}
