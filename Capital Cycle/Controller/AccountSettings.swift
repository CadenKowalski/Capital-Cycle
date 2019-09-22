//
//  AccountSettings.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 8/15/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AccountSettings: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // Storyboard outlets
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var userTypeLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var userTypePickerView: UIPickerView!
    // Code global vars
    let databaseRef = Firestore.firestore().collection("Users")
    var typesOfUser = ["Current", "Camper", "Parent", "Counselor"]
    
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
        
        // Sets the gradients
        gradientView.setGradientBackground()
        
        // Formats the profile image view
        profileImageView.layer.cornerRadius = 50
        
        // Formats the email and userType labels
        emailLbl.text = "Email: \((Auth.auth().currentUser?.email)!)"
        userTypeLbl.text = "I am a " + "\(userType!)".capitalized
        if userType == .admin {
            userTypeLbl.text = "I am an " + "\(userType!)".capitalized
        }
        
        // Sets up the picker view
        cancelBtn.isHidden = true
        userTypePickerView.delegate = self
        userTypePickerView.dataSource = self
    }
    
    // Dismisses the UIPickerView
    @IBAction func dismissUserTypePickerView(_ sender: Any) {
        userTypePickerView.isHidden = true
        cancelBtn.isHidden = true
    }
    
    // Shows an alert
    func showAlert(title: String, message: String, actionTitle: String, actionStyle: UIAlertAction.Style) {
        let Alert = UIAlertController(title: title, message:  message, preferredStyle: .alert)
        Alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
        present(Alert, animated: true, completion: nil)
    }
    
    // MARK: UIPickerView Setup
    
    // Sets the number of columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Sets the number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    // Sets titles for respective rows
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typesOfUser[row]
    }
    
    // Called when the picker view is used
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if typesOfUser[row] == "Camper" {
            userType = .camper
        } else if typesOfUser[row] == "Parent" {
            userType = .parent
        } else {
            userType = .counselor
        }
        
        userTypePickerView.isHidden = true
        cancelBtn.isHidden = true
        if typesOfUser[row] != "Current" {
            userTypeLbl.text = "I am a " + "\(typesOfUser[row])".capitalized
            if userType == .admin {
                userTypeLbl.text = "I am an " + "\(typesOfUser[row])".capitalized
            }
        }
    }
    
    // MARK: Settings
    
    // Changes the User Type
    @IBAction func changeUserType(_ sender: UIButton) {
        if userTypePickerView.isHidden {
            userTypePickerView.isHidden = false
            cancelBtn.isHidden = false
        } else {
            userTypePickerView.isHidden = true
            cancelBtn.isHidden = true
        }
    }
    
    // Logs out the user
    @IBAction func logOut(_ sender: UIButton?) {
        signedIn = false
        do {
            if sender == nil {
                let email = Auth.auth().currentUser?.email
                Auth.auth().currentUser?.delete(completion: { error in
                    if error == nil {
                        self.databaseRef.document(email!).delete(completion: { error in
                            if error != nil {
                                self.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default)
                            }
                        })
                    } else {
                        self.showAlert(title: "Delete Failed", message: "Error: \(error!.localizedDescription)", actionTitle: "OK", actionStyle: .default)
                    }
                })
            } else {
                updateUser(email: (Auth.auth().currentUser?.email)!)
            }
            
            try Auth.auth().signOut()
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } catch let error as NSError {
            showAlert(title: "Error", message: error.localizedDescription, actionTitle: "OK", actionStyle: .default)
        }
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
            Auth.auth().sendPasswordReset(withEmail: userEmail!, completion: { error in
                if error == nil {
                    self.showAlert(title: "Email sent successfully", message: "Check your email to reset password", actionTitle: "OK", actionStyle: .default)
                } else {
                    self.showAlert(title: "Reset Failed", message: "Error: \(error!.localizedDescription)", actionTitle: "OK", actionStyle: .default)
                }
            })
        }))
        
        self.present(resetPasswordAlert, animated: true, completion: nil)
    }
    
    // Allows the user to delete their account
    @IBAction func deleteAccount(_ sender: UIButton) {
        let confirmDeleteAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        confirmDeleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        confirmDeleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            self.logOut(nil)
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
