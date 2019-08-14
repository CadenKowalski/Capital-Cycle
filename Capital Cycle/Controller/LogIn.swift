//
//  LogIn.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/20/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LogIn: UIViewController, UITextFieldDelegate {

    // Storyboard outlets
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passTxtField: UITextField!
    @IBOutlet weak var signedInBtn: UIButton!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var logInBtnProgressWheel: UIActivityIndicatorView!
    // Code global vars
    let databaseRef = Firestore.firestore().collection("Users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeLayout()
    }
    
    // Logs in a user automatically if they have already logged in
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Auth.auth().currentUser?.reload(completion: { (action) in
            if Auth.auth().currentUser != nil {
                self.formatProgressWheel(toShow: true)
                self.fetchUserValues(email: (Auth.auth().currentUser?.email)!) {
                    if Auth.auth().currentUser != nil && signedIn == true {
                        self.performSegue(withIdentifier: "AlreadyLoggedIn", sender: nil)
                        self.formatProgressWheel(toShow: false)
                    }
                    
                    self.formatProgressWheel(toShow: false)
                }
            }
        })
    }
    
    // MARK: View Setup / Management
    
    // Formats the UI
    func customizeLayout() {
        //Formats the grdient view
        if view.frame.height < 700 {
            gradientViewHeight.constant = 0.15 * view.frame.height
            gradientView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.15)
        }
        
        // Sets the gradients
        gradientView.setGradientBackground()
        logInBtn.setGradientButton(cornerRadius: 22.5)

        // Sets up the text fields
        emailTxtField.delegate = self
        passTxtField.delegate = self
        emailTxtField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
        passTxtField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
        
        // Formats the progress wheel
        logInBtnProgressWheel.isHidden = true
    }
    
    // Keep the user signed in or not
    @IBAction func keepSignedIn(_ sender: UIButton) {
        if !signedIn {
            signedIn = true
            sender.setImage(UIImage(named: "Checked"), for: .normal)
        } else {
            signedIn = false
            sender.setImage(UIImage(named: "Unchecked"), for: .normal)
        }
    }
    
    // Shows an alert
    func showAlert(title: String, message: String, actionTitle: String, actionStyle: UIAlertAction.Style) {
        let Alert = UIAlertController(title: title, message:  message, preferredStyle: .alert)
        Alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
        present(Alert, animated: true, completion: nil)
    }
    
    func formatProgressWheel(toShow: Bool) {
        if toShow {
            logInBtnProgressWheel.isHidden = false
            logInBtn.alpha = 0.25
            logInBtnProgressWheel.startAnimating()
        } else {
            logInBtnProgressWheel.isHidden = true
            logInBtn.alpha = 1.0
            logInBtnProgressWheel.stopAnimating()
        }
    }
    
    // MARK: Log In
    
    // Logs the user in
    @IBAction func logIn(_ sender: UIButton) {
        formatProgressWheel(toShow: true)
        Auth.auth().signIn(withEmail: emailTxtField.text!, password: passTxtField.text!) {(user, error) in
            if error == nil {
                self.updateUser(email: (Auth.auth().currentUser?.email)!)
                self.fetchUserValues(email: (Auth.auth().currentUser?.email)!) {
                    self.performSegue(withIdentifier: "LogIn", sender: self)
                }
            } else {
                self.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default)
            }
            
            self.formatProgressWheel(toShow: false)
        }
    }
    
    // Resets the users password
    @IBAction func resetPassword(_ sender: UIButton) {
        let resetPasswordAlert = UIAlertController(title: "Reset Password", message: "Enter your email adress", preferredStyle: .alert)
            resetPasswordAlert.addTextField { (textField) in
                textField.placeholder = "Email"
                textField.keyboardType = .emailAddress
                textField.font = UIFont(name: "Avenir-Book", size: 13.0)
            }
            
            resetPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            resetPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (Action) in
                let userEmail = resetPasswordAlert.textFields?.first?.text
                Auth.auth().sendPasswordReset(withEmail: userEmail!, completion: { (Error) in
                    if Error != nil {
                        self.showAlert(title: "Reset Falied", message: "Error: \(Error!.localizedDescription)", actionTitle: "OK", actionStyle: .default)
                    } else {
                        self.showAlert(title: "Email sent successfully", message: "Check your email to reset password", actionTitle: "OK", actionStyle: .default)
                    }
                })
            }))
        
        self.present(resetPasswordAlert, animated: true, completion: nil)
    }
    
    // MARK: Firebase
    
    func updateUser(email: String) {
        databaseRef.document(email).updateData(["signedIn": signedIn!]) { error in
            if error != nil {
                self.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default)
            }
        }
    }
    
    // Fetches user values from the Firebase Firestore
    func fetchUserValues(email: String, completion: @escaping() -> Void) {
        let userRef = databaseRef.document(email)
        userRef.getDocument { (document, error) in
            if error == nil {
                signedIn = document?.get("signedIn") as? Bool
                switch document?.get("Type") as! String {
                case "Camper":
                    userType = .camper
                case "Parent":
                    userType = .parent
                case "Counselor":
                    userType = .counselor
                case "Admin":
                    userType = .admin
                default:
                    return
                }
                
                completion()
            } else {
                self.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default)
                completion()
            }
        }
    }
    
    // MARK: Dismiss Keyboard
    
    // Dismiss keyboard when "done" is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // Dismiss keyboard when view tapped
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
