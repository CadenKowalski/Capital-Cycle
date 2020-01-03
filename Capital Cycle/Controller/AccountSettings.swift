//
//  AccountSettings.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 8/15/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import Firebase

class AccountSettings: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Global Variables
    
    // Storyboard outlets
    @IBOutlet weak var gradientView: CustomView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var profileImgView: CustomImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var userTypeLbl: UILabel!
    @IBOutlet weak var accountSettingsProgressWheel: UIActivityIndicatorView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var userTypePickerView: UIPickerView!
    // Code global vars
    var typesOfUser = ["Current", "Camper", "Parent", "Counselor"]
    
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
        userTypeLbl.text = "I am a " + "\(user.type!)".capitalized
        if user.type == .admin {
            userTypeLbl.text = "I am an " + "\(user.type!)".capitalized
        }
        
        // Formats the picker view
        cancelBtn.isHidden = true
        userTypePickerView.delegate = self
        userTypePickerView.dataSource = self
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
            destination.presentedFromSegue = true
        }
    }
    
    // MARK: Settings
    
    // Changes the User Type
    @IBAction func changeUserType(_ sender: UIButton) {
        viewFunctions.giveHapticFeedback(error: false)
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
                } else {
                    viewFunctions.showAlert(title: "Error", message: error!, actionTitle: "OK", actionStyle: .default, view: self)
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
        
    // Logs out the user
    @IBAction func logOut(_ sender: UIButton?) {
        viewFunctions.formatProgressWheel(progressWheel: accountSettingsProgressWheel, button: nil, toShow: true)
        firebaseFunctions.logOut() { error in
            if error == nil {
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            } else {
                viewFunctions.showAlert(title: "Error", message: error!, actionTitle: "OK", actionStyle: .default, view: self)
            }
            
            viewFunctions.formatProgressWheel(progressWheel: self.accountSettingsProgressWheel, button: nil, toShow: false)
        }
    }
    
    // Resets the user's password
    @IBAction func resetPassword(_ sender: UIButton) {
        viewFunctions.giveHapticFeedback(error: false)
        let resetPasswordAlert = UIAlertController(title: "Reset Password", message: "Enter your email adress", preferredStyle: .alert)
        resetPasswordAlert.addTextField { textField in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
            textField.font = UIFont(name: "Avenir-Book", size: 13.0)
        }
        
        resetPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        resetPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .destructive, handler: { Action in
            viewFunctions.formatProgressWheel(progressWheel: self.accountSettingsProgressWheel, button: nil, toShow: true)
            firebaseFunctions.resetPassword(recoveryEmail: (resetPasswordAlert.textFields?.first!.text)!) { error in
                if error == nil {
                    viewFunctions.showAlert(title: "Success", message: "You have been sent a password reset email", actionTitle: "OK", actionStyle: .default, view: self)
                } else {
                    print("Could not reset password")
                }
                
                viewFunctions.formatProgressWheel(progressWheel: self.accountSettingsProgressWheel, button: nil, toShow: false)
            }
        }))
        
        self.present(resetPasswordAlert, animated: true, completion: nil)
    }
    
    // Allows the user to delete their account
    @IBAction func deleteAccount(_ sender: UIButton) {
        viewFunctions.giveHapticFeedback(error: false)
        let confirmDeleteAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        confirmDeleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        confirmDeleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            viewFunctions.formatProgressWheel(progressWheel: self.accountSettingsProgressWheel, button: nil, toShow: true)
            firebaseFunctions.deleteAccount() { error in
                if error == nil {
                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                } else {
                    print("Could not delete account")
                }
                
                viewFunctions.formatProgressWheel(progressWheel: self.accountSettingsProgressWheel, button: nil, toShow: false)
            }
        }))
        
        self.present(confirmDeleteAlert, animated: true, completion: nil)
    }
}
