//
//  AccountSettings.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 8/15/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import Firebase
import MessageUI
import AuthenticationServices

class AccountSettings: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ASWebAuthenticationPresentationContextProviding, MFMailComposeViewControllerDelegate  {
    
    // MARK: Global Variables
    
    // Storyboard outlets
    @IBOutlet weak var gradientView: CustomView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var profileImgView: CustomImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var userTypeLbl: UILabel!
    @IBOutlet weak var reportBugLbl: CustomLabel!
    @IBOutlet weak var suggestFeedbackLbl: CustomLabel!
    @IBOutlet weak var googleAccessSwitch: UISwitch!
    @IBOutlet weak var accountSettingsProgressWheel: UIActivityIndicatorView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var userTypePickerView: UIPickerView!
    @IBOutlet weak var resetPasswordBtn: UIButton!
    // Code global vars
    var typesOfUser = ["Current", "Camper", "Parent", "Counselor"]
    var deletingAccount: Bool?
    var currentNonce: String?
    
    // MARK: View Instantiation
    
    // Runs when the view is loaded for the first time
    override func viewDidLoad() {
        super.viewDidLoad()
        formatUI()
    }
    
    // MARK: View Formatting
    
    // Formats the UI
    func formatUI() {
        // Formats the gradient view
        if view.frame.height < 700 {
            gradientViewHeight.constant = 0.15 * view.frame.height
            gradientView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.15)
        }

        // Formats the profile image view
        profileImgView.image = user.profileImg
        
        // Formats the email and userType labels
        emailLbl.text = "Email: \((Auth.auth().currentUser?.email)!)"
        userTypeLbl.text = "I am a " + "\(user.type!)"
        if user.type == .admin {
            userTypeLbl.text = "I am an " + "\(user.type!)"
        }
        
        // Formats the rebort a bug label
        let reportAttributedString = NSMutableAttributedString.init(string: "* As a 16 year old, I simply cannot make everything perfect. If you have any trouble with the app, please let me know.")
        reportAttributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange.init(location: 99, length: 19))
        reportBugLbl.attributedText = reportAttributedString
        
        // Formats the suggest feedback label
        let feedbackAttributedString = NSMutableAttributedString.init(string: "* Alternatively, if you have any suggestions to improve the app or user exprience, please let me know as well.")
        feedbackAttributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange.init(location: 83, length: 27))
        suggestFeedbackLbl.attributedText = feedbackAttributedString
        
        // Formats the google access switch
        googleAccessSwitch.isOn = user.isGoogleVerified
        
        // Formats the picker view
        cancelBtn.isHidden = true
        userTypePickerView.delegate = self
        userTypePickerView.dataSource = self
        
        // Formats the reset password button
        if user.authenticationMethod == "Apple" {
            resetPasswordBtn.isUserInteractionEnabled = false
            resetPasswordBtn.setTitleColor(UIColor(named: "CellColor"), for: .normal)
        }
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
    
    // MARK: View Management
    
    // Dismisses the UIPickerView
    @IBAction func dismissUserTypePickerView(_ sender: UIButton) {
        userTypePickerView.isHidden = true
        cancelBtn.isHidden = true
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
        switch typesOfUser[row] {
        case "Camper":
            user.type = .camper
            
        case "Parent":
            user.type = .parent
            
        case "Counselor":
            performSegue(withIdentifier: "VerifyCounselorFromSettings", sender: nil)
            
        default:
            break
        }
        
        userTypePickerView.isHidden = true
        cancelBtn.isHidden = true
        if typesOfUser[row] != "Current" {
            firebaseFunctions.manageUserData(dataValues: ["type"], newUser: false) { error in
                if error == nil {
                    self.userTypeLbl.text = "I am a " + "\(self.typesOfUser[row])".capitalized
                    if user.type == .admin {
                        self.userTypeLbl.text = "I am an " + "\(self.typesOfUser[row])".capitalized
                    }
                } else {
                    viewFunctions.showAlert(title: "Error", message: error!, actionTitle: "OK", actionStyle: .default, view: self)
                }
            }
        }
    }
    
    // Prepares VerifyCounselor for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "VerifyCounselorFromSettings" {
            let destination = segue.destination as! VerifyCounselor
            destination.presentingVC = "Account Settings"
        }
    }
    
    // MARK: Settings
    
    // Changes the User Type
    @IBAction func changeUserType(_ sender: UIButton) {
        viewFunctions.giveHapticFeedback(error: false, prefers: user.prefersHapticFeedback!)
        if userTypePickerView.isHidden {
            userTypePickerView.isHidden = false
            cancelBtn.isHidden = false
        } else {
            userTypePickerView.isHidden = true
            cancelBtn.isHidden = true
        }
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
            firebaseFunctions.manageUserData(dataValues: ["profileImgUrl"], newUser: false) { error in
                if error == nil {
                    self.profileImgView.image = user.profileImg
                    overviewPage?.setProfileImg()
                    schedulePage?.setProfileImg()
                    storePage?.setProfileImg()
                    faqPage?.setProfileImg()
                    camperInfoPage?.setProfileImg()
                } else {
                    viewFunctions.showAlert(title: "Error", message: error!, actionTitle: "OK", actionStyle: .default, view: self)
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reportBug(_ sender: UITapGestureRecognizer) {
        let Alert = UIAlertController(title: nil, message:  nil, preferredStyle: .actionSheet)
        Alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        Alert.addAction(UIAlertAction(title: "Send and email", style: .default, handler: { error in
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["cadenkowalski1@gmail.com"])
                if sender.view == self.reportBugLbl {
                    mail.setSubject("Bug Report")
                } else {
                    mail.setSubject("App Suggestion")
                }
                mail.setMessageBody("<p>Caden, </p>", isHTML: true)
                self.present(mail, animated: true)
            } else {
                viewFunctions.showAlert(title: "Error", message: "Could not compose email", actionTitle: "OK", actionStyle: .default, view: self)
            }
        }))
            
        present(Alert, animated: true, completion: nil)
    }
    
    @IBAction func googleAccess(_ sender: UISwitch) {
        if sender.isOn {
            googleFunctions.getAuthCode(context: self)
        } else {
            user.isGoogleVerified = false
            googleFunctions.revokeToken() { error in
                if error == nil {
                    camperInfoPage?.updateData(nil)
                } else {
                    print(error!)
                }
            }
        }
    }
    
    // Logs out the user
    @IBAction func logOut(_ sender: UIButton?) {
        viewFunctions.formatProgressWheel(progressWheel: accountSettingsProgressWheel, button: nil, toShow: true, hapticFeedback: false)
        firebaseFunctions.logOut() { error in
            if error == nil {
                viewFunctions.giveHapticFeedback(error: false, prefers: true)
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            } else {
                viewFunctions.showAlert(title: "Error", message: error!, actionTitle: "OK", actionStyle: .default, view: self)
            }
            
            viewFunctions.formatProgressWheel(progressWheel: self.accountSettingsProgressWheel, button: nil, toShow: false, hapticFeedback: false)
        }
    }
    
    // Gets the user's authorization to reset threir password
    @IBAction func resetPassword(_ sender: UIButton) {
        let resetPasswordAlert = UIAlertController(title: "Reset Password", message: "Enter your email adress, we will send you a password reset email", preferredStyle: .alert)
        resetPasswordAlert.addTextField { textField in
            textField.keyboardType = .emailAddress
            textField.textContentType = .username
            textField.font = UIFont(name: "Avenir-Book", size: 13.0)
            textField.attributedText = NSAttributedString(string: "\(user.email!)", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "LabelColor")!, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
        }
        
        resetPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        resetPasswordAlert.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { action in
            firebaseFunctions.resetPassword(recoveryEmail: (resetPasswordAlert.textFields?.first!.text)!) { error in
                if error == nil {
                    viewFunctions.showAlert(title: "Success", message: "You have been sent a password reset email", actionTitle: "OK", actionStyle: .default, view: self)
                } else {
                    print("Could not reset password")
                }
            }
        }))
        
        present(resetPasswordAlert, animated: true, completion: nil)
    }
    
    // Gets the user's authorization to delete their account
    @IBAction func getAuthorization(_ sender: UIButton) {
        authenticationFunctions.authenticateUser() { error in
            if error == nil {
                self.deleteAccount()
            } else if error == "Fallback" {
                if user.authenticationMethod == "Email" {
                    let enterPasswordAlert = UIAlertController(title: "Enter your password", message: nil, preferredStyle: .alert)
                    enterPasswordAlert.addTextField() { textField in
                        textField.placeholder = "Password"
                        textField.textContentType = .password
                        textField.isSecureTextEntry = true
                        textField.font = UIFont(name: "Avenir-Book", size: 13.0)
                    }
                    
                    enterPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    enterPasswordAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
                        let credential = EmailAuthProvider.credential(withEmail: user.email!, password: enterPasswordAlert.textFields!.first!.text!)
                        Auth.auth().currentUser?.reauthenticate(with: credential) { (authResult, error) in
                            if error == nil {
                                self.deleteAccount()
                            } else {
                                viewFunctions.showAlert(title: "Uh Oh", message: "The password you entered is incorrect", actionTitle: "OK", actionStyle: .default, view: self)
                            }
                        }
                    }))
                    
                    self.present(enterPasswordAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // Deletes the user's account after recieving authorization
    func deleteAccount() {
        let confirmDeleteAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        confirmDeleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        confirmDeleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            firebaseFunctions.deleteAccount() { error in
                if error == nil {
                    viewFunctions.giveHapticFeedback(error: false, prefers: user.prefersHapticFeedback!)
                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                } else {
                    print(error!)
                }
            }
        }))
        
        present(confirmDeleteAlert, animated: true, completion: nil)
    }
    
    // Called when authentication fails on the user end
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error: \(error)")
    }
}
