//
//  SignUp.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/20/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import Firebase

class SignUp: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Storyboard outlets
    @IBOutlet weak var gradientView: CustomView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var profileImgView: CustomImageView!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passTxtField: UITextField!
    @IBOutlet weak var confmPassTxtField: UITextField!
    @IBOutlet weak var userTypeLbl: CustomLabel!
    @IBOutlet weak var signedInBtn: UIButton!
    @IBOutlet weak var signUpBtn: CustomButton!
    @IBOutlet weak var signUpBtnProgressWheel: UIActivityIndicatorView!
    @IBOutlet weak var privacyPolicyTxtView: CustomTextView!
    @IBOutlet weak var userTypePickerView: UIPickerView!
    // Code global vars
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
        
        // Sets up the text fields
        emailTxtField.delegate = self
        passTxtField.delegate = self
        confmPassTxtField.delegate = self
        emailTxtField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
        passTxtField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
        confmPassTxtField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
        
        // Formats the progress wheel
        signUpBtnProgressWheel.isHidden = true
        
        // Sets up the picker view
        userTypePickerView.delegate = self
        userTypePickerView.dataSource = self
    }
    
    // Displays the image picker to allow users to set/reset their profile image
    @IBAction func chooseProfileImg(_ sender: UITapGestureRecognizer) {
        let Alert = UIAlertController(title: nil, message: "How do you want to select your image?", preferredStyle: .actionSheet)
        Alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: nil))
        Alert.addAction(UIAlertAction(title: "Photos Library", style: .default, handler:  { (Action) in
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        Alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(Alert, animated: true, completion: nil)
    }
    
    // Sets the selected image to the users profile image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let Image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            user.profileImg = Image
            profileImgView.image = user.profileImg
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // Keep the user signed in or not
    @IBAction func keepSignedIn(_ sender: UIButton) {
        giveHapticFeedback(error: false)
        if !user.signedIn! {
            user.signedIn = true
            sender.setImage(UIImage(named: "Checked"), for: .normal)
        } else {
            user.signedIn = false
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
        giveHapticFeedback(error: false)
        if !Agree {
            Agree = true
            sender.setImage(UIImage(named: "Checked"), for: .normal)
        } else {
            Agree = false
            sender.setImage(UIImage(named: "Unchecked"), for: .normal)
        }
    }
    
    // Initiates haptic feedback
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
    
    // Shows an alert
    func showAlert(title: String, message: String, actionTitle: String, actionStyle: UIAlertAction.Style) {
        let Alert = UIAlertController(title: title, message:  message, preferredStyle: .alert)
        Alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
        present(Alert, animated: true, completion: nil)
        giveHapticFeedback(error: true)
    }
    
    // Switches on and off the progress wheel
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
            user.type = FirebaseUser.type.none
        } else if typesOfUser[row] == "Camper" {
            user.type = .camper
        } else if typesOfUser[row] == "Parent" {
            user.type = .parent
        } else {
            user.type = .counselor
        }
        
        userTypePickerView.isHidden = true
        userTypeLbl.text = typesOfUser[row]
        if user.type != FirebaseUser.type.none {
            userTypeLbl.backgroundColor = #colorLiteral(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
            userTypeLbl.alpha = 1.0
            giveHapticFeedback(error: false)
        }
    }
    
    // MARK: Sign Up

    // Verifies the users information
    @IBAction func verifyInputs(_ sender: CustomButton) {
        let email = emailTxtField.text ?? ""
        let password = passTxtField.text ?? ""
        if email == "cadenkowalski1@gmail.com" {
            user.type = .admin
        }

        if password != confmPassTxtField.text {
            showAlert(title: "Passwords don't match", message: "Please make sure your passwords match", actionTitle: "OK", actionStyle: .default)
        } else if Agree == false {
            showAlert(title: "Uh oh", message: "Please agree to the privacy policy and terms of serivce", actionTitle: "OK", actionStyle: .default)
        } else if user.type == FirebaseUser.type.none && user.type != .admin {
            userTypeLbl.backgroundColor = .red
            userTypeLbl.alpha = 0.5
            giveHapticFeedback(error: true)
        } else if passwordIsTooWeak(password: password) && password.count > 5 {
            let Alert = UIAlertController(title: "Password not recommended", message: "We recommend that your password contain a number or symbol and be different cases", preferredStyle: .alert)
            Alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            Alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { action in
                self.signUp(email: email, password: password)
            }))
            
            present(Alert, animated: true, completion: nil)
        } else {
            signUp(email: email, password: password)
        }
    }
    
    // Signs up the user
    func signUp(email: String, password: String) {
        formatProgressWheel(toShow: true)
        user.email = email
        user.password = password
        Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
            if error == nil {
                if user.type == .counselor  || user.type == .admin {
                    self.performSegue(withIdentifier: "VerifyCounselor", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "VerifyUser", sender: nil)
                    Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                }
                
                self.getProfileImgUrl()
            } else {
                self.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default)
            }
            
            self.formatProgressWheel(toShow: false)
        }
    }
    
    // Tests if a password is too weak
    func passwordIsTooWeak(password: String) -> Bool {
        var tooWeak: Bool
        var passwordContainsSymbol = false
        let letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        for letter in password {
            if !letters.contains(String(letter)) {
                passwordContainsSymbol = true
            }
        }
        
        if !passwordContainsSymbol {
            tooWeak = true
        } else if password == password.lowercased() || password == password.uppercased() {
            tooWeak = true
        } else {
            tooWeak = false
        }
        
        return tooWeak
    }
    
    // MARK: Firebase
    
    // Uploads the users profile image to Firebase
    func getProfileImgUrl() {
        let uid = Auth.auth().currentUser?.uid
        let storageReference = Storage.storage().reference().child("user/\(String(describing: uid))")
        let imageData = user.profileImg!.jpegData(compressionQuality: 1.0)!
        storageReference.putData(imageData, metadata: nil) { (metaData, error) in
            if error == nil {
                storageReference.downloadURL(completion: { (url, error) in
                    if error == nil {
                        let urlString = url?.absoluteString
                        user.profileImgUrl = urlString
                    } else {
                        self.showAlert(title: "Error", message: "Could not upload image", actionTitle: "OK", actionStyle: .default)
                    }
                })
            } else {
                self.showAlert(title: "Error", message: "Could not upload image", actionTitle: "OK", actionStyle: .default)
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
