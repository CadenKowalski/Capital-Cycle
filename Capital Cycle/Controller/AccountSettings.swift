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

    // Storyboard outlets
    @IBOutlet weak var gradientView: CustomView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var profileImgView: CustomImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var userTypeLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var userTypePickerView: UIPickerView!
    // Code global vars
    static let Instance = AccountSettings()
    let firebaseFunctions = FirebaseFunctions()
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

        // Formats the profile image view
        profileImgView.image = user.profileImg
        
        // Formats the email and userType labels
        emailLbl.text = "Email: \((Auth.auth().currentUser?.email)!)"
        userTypeLbl.text = "I am a " + "\(user.type!)".capitalized
        if user.type == .admin {
            userTypeLbl.text = "I am an " + "\(user.type!)".capitalized
        }
        
        // Sets up the picker view
        cancelBtn.isHidden = true
        userTypePickerView.delegate = self
        userTypePickerView.dataSource = self
    }
    
    // Initiates haptic feedback
    func giveHapticFeedback() {
        if user.prefersHapticFeedback! {
            let feedbackGenerator = UISelectionFeedbackGenerator()
            feedbackGenerator.selectionChanged()
        }
    }
    
    // Dismisses the UIPickerView
    @IBAction func dismissUserTypePickerView(_ sender: UIButton) {
        userTypePickerView.isHidden = true
        cancelBtn.isHidden = true
    }
    
    // Shows an alert
    func showAlert(title: String, message: String, actionTitle: String, actionStyle: UIAlertAction.Style) {
        let Alert = UIAlertController(title: title, message:  message, preferredStyle: .alert)
        Alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
        present(Alert, animated: true, completion: nil)
        if user.prefersHapticFeedback! {
            let feedbackGenerator = UINotificationFeedbackGenerator()
            feedbackGenerator.prepare()
            feedbackGenerator.notificationOccurred(.error)
        }
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
            user.type = .camper
        } else if typesOfUser[row] == "Parent" {
            user.type = .parent
        } else {
            user.type = .counselor
        }
        
        userTypePickerView.isHidden = true
        cancelBtn.isHidden = true
        if typesOfUser[row] != "Current" {
            userTypeLbl.text = "I am a " + "\(typesOfUser[row])".capitalized
            if user.type == .admin {
                userTypeLbl.text = "I am an " + "\(typesOfUser[row])".capitalized
            }

            firebaseFunctions.updateUserData()
        }
    }
    
    // MARK: Settings
    
    // Changes the User Type
    @IBAction func changeUserType(_ sender: UIButton) {
        giveHapticFeedback()
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
            profileImgView.image = user.profileImg
            firebaseFunctions.updateUserData()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Firebase
    
    // Logs out the user
    @IBAction func logOut(_ sender: UIButton?) {
        firebaseFunctions.logOut(sender)
    }
    
    // Resets the user's password
    @IBAction func resetPassword(_ sender: UIButton) {
        firebaseFunctions.resetPassword()
    }
    
    // Allows the user to delete their account
    @IBAction func deleteAccount(_ sender: UIButton) {
        firebaseFunctions.deleteAccount()
    }
}
