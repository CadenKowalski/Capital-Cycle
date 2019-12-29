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
    // Global code vars
    let databaseRef = Firestore.firestore().collection("Users")
    var senderVC: String!
    
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
        
        // Determines the sender view controller
        if SignUp.Instance.signUpEmail != nil {
            senderVC = "SignUp"
        } else {
            senderVC = "OneMoreStep"
        }
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
    
    // MARK: Sign Up
    
    // Signs up the user
    @IBAction func signUp(_ sender: CustomButton) {
        if counselorIdTxtField.text == "082404" {
            performSegue(withIdentifier: "VerifiedCounselor", sender: nil)
            giveHapticFeedback(error: false)
            if senderVC == "SignUp" {
                self.uploadUser(email: SignUp.Instance.signUpEmail)
            } else {
                self.uploadUser(email: OneMoreStep.Instance.signUpEmail)
            }
        } else {
            counselorIdTxtField.backgroundColor = .red
            counselorIdTxtField.alpha = 0.5
            giveHapticFeedback(error: true)
        }
    }
    
    // MARK: Firebase
    
    // Uploads a user to the Firebase Firestore
    func uploadUser(email: String) {
        var userTypeString: String
        switch userType {
        case .counselor:
            userTypeString = "Counselor"
        case .admin:
            userTypeString = "Admin"
        default:
            return
        }
        
        if senderVC == "SignUp" {
            databaseRef.document(email).setData(["email": email, "type": userTypeString, "signedIn": signedIn!,  "profileImgUrl": SignUp.Instance.profileImgUrl!]) { error in
                if error != nil {
                    self.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default)
                }
            }
        } else {
            databaseRef.document(email).setData(["email": email, "type": userTypeString, "signedIn": signedIn!,  "profileImgUrl": OneMoreStep.Instance.profileImgUrl!]) { error in
                if error != nil {
                    self.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default)
                }
            }
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
