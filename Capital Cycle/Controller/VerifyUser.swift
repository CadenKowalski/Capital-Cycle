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
    // Global code vars
    let databaseRef = Firestore.firestore().collection("Users")
    
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
        if hapticFeedback {
            let feedbackGenerator = UINotificationFeedbackGenerator()
            feedbackGenerator.prepare()
            feedbackGenerator.notificationOccurred(.error)
        }
    }
    
    // MARK: Sign Up
    
    // Checks if the user has verified their email
    @IBAction func checkForVerifiedUser(_ sender: UIButton) {
        Auth.auth().currentUser?.reload(completion: { (Action) in
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
        self.performSegue(withIdentifier: "verifiedUser", sender: nil)
        if hapticFeedback {
            let feedbackGenerator = UISelectionFeedbackGenerator()
            feedbackGenerator.selectionChanged()
        }
        self.uploadUser(email: (Auth.auth().currentUser?.email)!)
    }
    
    // MARK: Firebase
    
    // Uploads a user to the Firebase Firestore
    func uploadUser(email: String) {
        var userTypeString: String
        switch userType {
        case .camper:
            userTypeString = "Camper"
        case .parent:
            userTypeString = "Parent"
        default:
            return
        }
        
        databaseRef.document(email).setData(["email": email, "type": userTypeString, "signedIn": signedIn!, "profileImgUrl": SignUp.Instance.profileImgUrl!]) { error in
            if error != nil {
                self.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default)
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
