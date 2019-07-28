//
//  SignUp.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/20/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreData

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
    @IBOutlet weak var privacyPolicyTxtView: UITextView!
    @IBOutlet weak var userTypePickerView: UIPickerView!
    // Code global vars
    var Agree = false
    var typesOfUser = ["--", "Camper", "Parent", "Counselor"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        signUpBtn.setTwoGradientButton(colorOne: Colors.Orange, colorTwo: Colors.Purple, cornerRadius: 22.5)

        // Sets up the text fields
        emailTxtField.delegate = self
        passTxtField.delegate = self
        confmPassTxtField.delegate = self
        emailTxtField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
        passTxtField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
        confmPassTxtField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
        
        // FSets up the user type label
        userTypeLbl.isUserInteractionEnabled = true
        userTypeLbl.layer.cornerRadius = 6
        
        // Formats the privacy policy text view
        privacyPolicyTxtView.layer.cornerRadius = 20
        
        // Sets up the picker view
        userTypePickerView.delegate = self
        userTypePickerView.dataSource = self
    }

    // Displays the privacy policy text view
    @IBAction func privacyPolicy(_ sender: UIButton) {
        privacyPolicyTxtView.isHidden = false
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
    
    // Is called when the picker view is used
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
        
        userTypeLbl.text = typesOfUser[row]
        userTypePickerView.isHidden = true
    }
    
    // MARK: Sign Up
    
    // Defines the poosible types of users
    enum UserType {
        case none
        case camper
        case parent
        case counselor
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

    // Signs up the user
    @IBAction func signUp(_ sender: UIButton) {
        if passTxtField.text != confmPassTxtField.text {
            let Alert = UIAlertController(title: "Password Incorret", message: "Please make sure your passwords match", preferredStyle: .alert)
            let Action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            Alert.addAction(Action)
            present(Alert, animated: true, completion: nil)
        } else if Agree == false {
            let Alert = UIAlertController(title: "Error", message: "Please make sure you agree to the privacy policy and terms of serivce", preferredStyle: .alert)
            let Action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            Alert.addAction(Action)
            present(Alert, animated: true, completion: nil)
        } else if userType == SignUp.UserType.none {
            userTypeLbl.backgroundColor = .red
            userTypeLbl.alpha = 0.5
        } else {
            Auth.auth().createUser(withEmail: emailTxtField.text!, password: passTxtField.text!) { (user, error) in
                if error == nil {
                    self.createUser(email: self.emailTxtField.text!)
                    self.performSegue(withIdentifier: "SignUp", sender: self)
                } else {
                    let Alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let Action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    Alert.addAction(Action)
                    self.present(Alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: Core Data
    
    // Create a core data user
    func createUser(email: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let Context = appDelegate.persistentContainer.viewContext
        let User = NSEntityDescription.insertNewObject(forEntityName: "User", into: Context)
        User.setValue(email, forKey: "email")
        User.setValue(signedIn, forKey: "signedIn")
        switch userType {
        case .camper:
            User.setValue("Camper", forKey: "type")
        case .parent:
            User.setValue("Parent", forKey: "type")
        case .counselor:
            User.setValue("Counselor", forKey: "type")
        default:
            return
        }
        do {
            try Context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
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
