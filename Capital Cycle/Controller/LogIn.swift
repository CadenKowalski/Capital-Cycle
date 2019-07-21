//
//  LogIn.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/20/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogIn: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxtField.delegate = self
        passTxtField.delegate = self
        customizeLayout()
    }
    
    func customizeLayout() {
        emailTxtField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
        passTxtField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if emailTxtField.text != "" && passTxtField.text != "" {
            logIn()
        }
        return true
    }
    
    func logIn() {
        Auth.auth().signIn(withEmail: emailTxtField.text!, password: passTxtField.text!) { (user, error) in
            if error == nil {
                self.performSegue(withIdentifier: "LogIn", sender: self)
            } else {
                let Alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let Action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                Alert.addAction(Action)
                self.present(Alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        logIn()
    }
}
