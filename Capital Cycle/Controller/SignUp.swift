//
//  SignUp.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/20/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import Firebase

class SignUp: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    // Storyboard outlets
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passTxtField: UITextField!
    @IBOutlet weak var confmPassTxtField: UITextField!
    @IBOutlet weak var userTypeLbl: UILabel!
    @IBOutlet weak var signedInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var signUpBtnProgressWheel: UIActivityIndicatorView!
    @IBOutlet weak var privacyPolicyTxtView: UITextView!
    @IBOutlet weak var userTypePickerView: UIPickerView!
    // Code global vars
    static let Instance = SignUp()
    var signUpEmail: String!
    var signUpPass: String!
    var Agree = false
    var typesOfUser = ["--", "Camper", "Parent", "Counselor"]
    
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
        signUpBtn.setGradientButton(cornerRadius: 22.5)

        // Sets up the text fields
        emailTxtField.delegate = self
        passTxtField.delegate = self
        confmPassTxtField.delegate = self
        emailTxtField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
        passTxtField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
        confmPassTxtField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
        
        // Sets up the user type label
        userTypeLbl.isUserInteractionEnabled = true
        userTypeLbl.layer.cornerRadius = 6
        
        // Formats the privacy policy text view
        privacyPolicyTxtView.layer.cornerRadius = 20
        
        // Sets up the picker view
        userTypePickerView.delegate = self
        userTypePickerView.dataSource = self
        
        // Formats the progress wheel
        signUpBtnProgressWheel.isHidden = true
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
    
    // User declares of which type they are
    @IBAction func showUserTypes(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        if userTypePickerView.isHidden {
            userTypePickerView.isHidden = false
        } else {
            userTypePickerView.isHidden = true
        }
    }

    // Displays the privacy policy text view
    @IBAction func privacyPolicy(_ sender: UIButton) {
        privacyPolicyTxtView.isHidden = false
    }
    
    // User agrees to privacy policy and terms of service
    @IBAction func agreeToPolicies(_ sender: UIButton) {
        if !Agree {
            Agree = true
            sender.setImage(UIImage(named: "Checked"), for: .normal)
        } else {
            Agree = false
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
            signUpBtnProgressWheel.isHidden = false
            signUpBtn.alpha = 0.25
            signUpBtnProgressWheel.startAnimating()
        } else {
            signUpBtnProgressWheel.isHidden = true
            signUpBtn.alpha = 1.0
            signUpBtnProgressWheel.stopAnimating()
        }
    }
    
    // MARK: UIPickerView Setup
    
    // Defines the poosible types of users
    enum UserType {
        case none
        case camper
        case parent
        case counselor
        case admin
    }
    
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
        if typesOfUser[row] == "--" {
            userType = SignUp.UserType.none
        } else if typesOfUser[row] == "Camper" {
            userType = .camper
        } else if typesOfUser[row] == "Parent" {
            userType = .parent
        } else {
            userType = .counselor
        }
        
        userTypePickerView.isHidden = true
        userTypeLbl.text = typesOfUser[row]
        if userType != UserType.none {
            userTypeLbl.backgroundColor = #colorLiteral(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
            userTypeLbl.alpha = 1.0
        }
    }
    
    // MARK: Sign Up

    // Signs up the user
    @IBAction func signUp(_ sender: UIButton) {
        if emailTxtField.text == "cadenkowalski1@gmail.com" {
            userType = .admin
        }

        if passTxtField.text != confmPassTxtField.text {
            showAlert(title: "Passwords don't match", message: "Please make sure your passwords match", actionTitle: "OK", actionStyle: .default)
        } else if Agree == false {
            showAlert(title: "Uh oh", message: "Please agree to the privacy policy and terms of serivce", actionTitle: "OK", actionStyle: .default)
        } else if userType == SignUp.UserType.none && userType != .admin {
            userTypeLbl.backgroundColor = .red
            userTypeLbl.alpha = 0.5
        } else {
            formatProgressWheel(toShow: true)
            SignUp.Instance.signUpEmail = emailTxtField.text!
            SignUp.Instance.signUpPass = passTxtField.text!
            if userType == .counselor  || userType == .admin {
                self.performSegue(withIdentifier: "VerifyCounselor", sender: nil)
                formatProgressWheel(toShow: false)
            } else {
                Auth.auth().createUser(withEmail: emailTxtField.text!, password: passTxtField.text!) { (user, error) in
                    if error == nil {
                        self.performSegue(withIdentifier: "VerifyUser", sender: nil)
                        Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                    } else {
                        self.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default)
                    }
                    
                    self.formatProgressWheel(toShow: false)
                }
            }
        }
    }
    
    // MARK: Dismiss
    
    // Dismiss keybpard when "done" is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // Dismiss keyboard when view is tapped
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // Dismiss the privacy policy view when view is tapped
    @IBAction func dismissPrivacyPolicy(_ sender: UITapGestureRecognizer) {
        privacyPolicyTxtView.isHidden = true
    }
}
