//
//  Settings.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/21/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import Firebase

class Settings: UIViewController {

    // Storyboard outlets
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var signedInSwitch: UISwitch!
    // Code global vars
    let databaseRef = Firestore.firestore().collection("Users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeLayout()
    }
    
    // MARK: View Setup / Management
    
    // Formats the UI
    func customizeLayout() {
        // Formats the gradient view
        gradientViewHeight.constant = 0.15 * view.frame.height
        gradientView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.15)
        
        // Sets the gradients
        gradientView.setTwoGradientBackground()
        
        // Sets the "keep me signed in" switch to reflect the actual value
        if signedIn {
            signedInSwitch.isOn = true
        } else {
            signedInSwitch.isOn = false
        }
    }
    
    // Shows an alert
    func showAlert(title: String, message: String, actionTitle: String, actionStyle: UIAlertAction.Style) {
        let Alert = UIAlertController(title: title, message:  message, preferredStyle: .alert)
        Alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
        present(Alert, animated: true, completion: nil)
    }
    
    // MARK: Settings
    
    // Allows the user to update whether they want to stay signed in or not
    @IBAction func staySignedIn(_ sender: UISwitch) {
        if sender.isOn {
            signedIn = true
            updateUser(email: (Auth.auth().currentUser?.email)!)
        } else {
            signedIn = false
            updateUser(email: (Auth.auth().currentUser?.email)!)
        }
    }
    
    // Logs out the user
    @IBAction func logOut(_ sender: UIButton?) {
        do {
            try Auth.auth().signOut()
            if sender != nil {
                signedIn = false
                updateContext()
            }
        } catch let signOutError as NSError {
            showAlert(title: "Error", message: signOutError.localizedDescription, actionTitle: "OK", actionStyle: .default)
        }
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    // Resets the user's password
    @IBAction func resetPassword(_ sender: UIButton) {
        let resetPasswordAlert = UIAlertController(title: "Reset Password", message: "Enter your email adress", preferredStyle: .alert)
        resetPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
            textField.font = UIFont(name: "Avenir-Book", size: 13.0)
        }
        
        resetPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        resetPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .destructive, handler: { (Action) in
            let userEmail = resetPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: userEmail!, completion: { (Error) in
                if Error != nil {
                    self.showAlert(title: "Reset Failed", message: "Error: \(Error!.localizedDescription)", actionTitle: "OK", actionStyle: .default)
                } else {
                    self.showAlert(title: "Email sent successfully", message: "Check your email to reset password", actionTitle: "OK", actionStyle: .default)
                }
            })
        }))
        
        self.present(resetPasswordAlert, animated: true, completion: nil)
    }
    
    // Allows the user to delete their account
    @IBAction func deleteAccount(_ sender: UIButton) {
        let confirmDeleteAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        confirmDeleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        confirmDeleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (Action) in
            Auth.auth().currentUser?.delete(completion: { Error in
                if Error != nil {
                    self.showAlert(title: "Delete Failed", message: "Error: \(Error!.localizedDescription)", actionTitle: "OK", actionStyle: .default)
                } else {
                   self.logOut(sender)
                }
            })
        }))
        
        self.present(confirmDeleteAlert, animated: true, completion: nil)
    }
    
    // MARK: Firebase
    
    func updateUser(email: String) {
        databaseRef.document(email).updateData(["signedIn": signedIn!]) { error in
            if error != nil {
                self.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default)
            }
        }
    }
}
