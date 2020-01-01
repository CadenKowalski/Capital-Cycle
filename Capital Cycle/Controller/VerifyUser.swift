//
//  VerifyUser.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 8/4/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import Firebase

class VerifyUser: UIViewController, UIAdaptivePresentationControllerDelegate {
    
    // MARK: Global Variables
    
    // Storyboard outlets
    @IBOutlet weak var gradientView: CustomView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var signUpBtn: CustomButton!
    @IBOutlet weak var signUpBtnProgressWheel: UIActivityIndicatorView!
    
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
        
        // Prevents the user from dismissing the view without deleting their account
        isModalInPresentation = true
    }
    
    // MARK: Sign Up
    
    // Checks if the user has verified their email
    @IBAction func checkForVerifiedUser(_ sender: UIButton) {
        Auth.auth().currentUser?.reload(completion: { Action in
            if Auth.auth().currentUser!.isEmailVerified {
                self.refreshBtn.isHidden = true
                self.signUpBtn.isHidden = false
            } else {
                viewFunctions.showAlert(title: "Uh oh", message: "It looks like you haven't verified your email yet", actionTitle: "OK", actionStyle: .default, view: self)
            }
        })
    }
    
    // Signs up the user
    @IBAction func signUp(_ sender: CustomButton) {
        firebaseFunctions.fetchUserData(fetchValue: "all") { error in
            if error == nil {
                self.performSegue(withIdentifier: "VerifiedUser", sender: nil)
            } else {
                viewFunctions.showAlert(title: "Error", message: error!, actionTitle: "OK", actionStyle: .default, view: self)
            }
        }
    }
    
    // MARK: Dismiss
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let Alert = UIAlertController(title: nil, message: "This action will delete your account. Are you sure you want to continue?", preferredStyle: .actionSheet)
        Alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        Alert.addAction(UIAlertAction(title: "Delete my account", style: .destructive) { action in
            firebaseFunctions.deleteAccount()  { error in
                if error == nil {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    viewFunctions.showAlert(title: "Error", message: error!, actionTitle: "OK", actionStyle: .default, view: self)
                }
            }
        })
        
        present(Alert, animated: true, completion: nil)
    }
}
