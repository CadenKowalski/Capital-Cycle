//
//  SignUp.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/20/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUp: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passTxtField: UITextField!
    @IBOutlet weak var confmPassTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxtField.delegate = self
        passTxtField.delegate = self
        confmPassTxtField.delegate = self
        customizeLayout()
    }
    
    // MARK: View Setup
    
    // Formats the UI
    func customizeLayout() {
        // Formats the gradient view
        gradientViewHeight.constant = 0.15 * view.frame.height
        gradientView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.15)
        
        // Sets the gradients
        gradientView.setTwoGradientBackground(colorOne: Colors.Orange, colorTwo: Colors.Purple)

        // Formats the placeholder text
        emailTxtField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
        passTxtField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
        confmPassTxtField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
    }
    
    // MARK: Sign Up
    
    // Signs Up the user
    func signUp() {
        if passTxtField.text != confmPassTxtField.text {
            let Alert = UIAlertController(title: "Password Incorret", message: "Please make sure your passwords match", preferredStyle: .alert)
            let Action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            Alert.addAction(Action)
            present(Alert, animated: true, completion: nil)
        } else {
                Auth.auth().createUser(withEmail: emailTxtField.text!, password: passTxtField.text!) { (user, error) in
                if error == nil {
                    self.performSegue(withIdentifier: "SignUp", sender: self)
                } else {
                    let Alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let Action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    Alert.addAction(Action)
                    self.present(Alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: Dismiss Keyboard
    
    // Dismiss keybpard when "done" is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if emailTxtField.text != "" && passTxtField.text != "" && confmPassTxtField.text != "" {
            signUp()
        }
        return true
    }
    
    // Dismiss keyboard when view is tapped
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
