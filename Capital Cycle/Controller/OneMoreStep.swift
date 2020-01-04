//
//  OneMoreStep.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 12/26/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import Firebase

class OneMoreStep: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAdaptivePresentationControllerDelegate {
    
    // MARK: Global Variables
    
    // Storyboard outlets
    @IBOutlet weak var gradientView: CustomView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var profileImgView: CustomImageView!
    @IBOutlet var profileImgTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var userTypeLbl: CustomLabel!
    @IBOutlet weak var signedInBtn: UIButton!
    @IBOutlet weak var signUpBtn: CustomButton!
    @IBOutlet weak var signUpBtnProgressWheel: UIActivityIndicatorView!
    @IBOutlet weak var privacyPolicyTxtView: CustomTextView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var userTypePickerView: UIPickerView!
    // Code global vars
    var Agree = false
    var typesOfUser = ["--", "Camper", "Parent", "Counselor"]
    
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
        
        // Formats the privacy policy text view
        doneBtn.isHidden = true
        
        // Formats the picker view
        userTypePickerView.delegate = self
        userTypePickerView.dataSource = self
        
        // Prevents the user from dismissing the view without deleting their account
        isModalInPresentation = true
    }
    
    // MARK: View Management
    
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
    
    // User declares of which type they are
    @IBAction func showUserTypes(_ sender: UITapGestureRecognizer) {
        if userTypePickerView.isHidden {
            userTypePickerView.isHidden = false
        } else {
            userTypePickerView.isHidden = true
        }
    }

    // Displays the privacy policy text view
    @IBAction func privacyPolicy(_ sender: UIButton) {
        privacyPolicyTxtView.isHidden = false
        doneBtn.isHidden = false
        isModalInPresentation = true
    }
    
    @IBAction func dismissPrivacyPolicy(_ sender: UIButton) {
        privacyPolicyTxtView.isHidden = true
        sender.isHidden = true
        isModalInPresentation = false
    }
    
    // User agrees to privacy policy and terms of service
    @IBAction func agreeToPolicies(_ sender: UIButton) {
        viewFunctions.giveHapticFeedback(error: false, prefers: true)
        if !Agree {
            Agree = true
            sender.setImage(UIImage(named: "Checked"), for: .normal)
        } else {
            Agree = false
            sender.setImage(UIImage(named: "Unchecked"), for: .normal)
        }
    }
    
    // Keep the user signed in or not
    @IBAction func keepSignedIn(_ sender: UIButton) {
        viewFunctions.giveHapticFeedback(error: false, prefers: true)
        if !user.signedIn! {
            user.signedIn = true
            sender.setImage(UIImage(named: "Checked"), for: .normal)
        } else {
            user.signedIn = false
            sender.setImage(UIImage(named: "Unchecked"), for: .normal)
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
        }
    }
    
    // MARK: Sign Up
    
    // Verifies the user's inputs and signs in the user
    @IBAction func verifyInputs(_ sender: CustomButton) {
        if user.email == "cadenkowalski1@gmail.com" || user.email == "tester@test.com" {
            user.type = .admin
        }
        
        if Agree == false {
            viewFunctions.showAlert(title: "Uh oh", message: "Please agree to the privacy policy and terms of serivce", actionTitle: "OK", actionStyle: .default, view: self)
        } else if user.type == FirebaseUser.type.none && user.type != .admin {
            userTypeLbl.backgroundColor = .red
            userTypeLbl.alpha = 0.5
            viewFunctions.giveHapticFeedback(error: true, prefers: true)
        } else {
            signUp()
        }
    }
    
    // Signs up the user
    func signUp() {
        viewFunctions.formatProgressWheel(progressWheel: self.signUpBtnProgressWheel, button: self.signUpBtn, toShow: true, hapticFeedback: true)
        if user.type == .counselor {
            self.performSegue(withIdentifier: "VerifyCounselorFromApple", sender: nil)
            viewFunctions.formatProgressWheel(progressWheel: self.signUpBtnProgressWheel, button: self.signUpBtn, toShow: false, hapticFeedback: false)
        } else {
            firebaseFunctions.manageUserData(dataValues: ["all"], newUser: true) { error in
                if error == nil {
                    self.performSegue(withIdentifier: "VerifiedUserFromApple", sender: nil)
                } else {
                    viewFunctions.showAlert(title: "Error", message: error!, actionTitle: "OK", actionStyle: .default, view: self)
                }
                
                viewFunctions.formatProgressWheel(progressWheel: self.signUpBtnProgressWheel, button: self.signUpBtn, toShow: false, hapticFeedback: false)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "VerifyCounselorFromApple" {
            let destination = segue.destination as! VerifyCounselor
            destination.presentingVC = "OneMoreStep"
        }
    }
    
    // MARK: Dismiss
    
    // Deletes the users account if they dismiss the OneMoreStep view
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let Alert = UIAlertController(title: nil, message: "This action will delete your account. Are you sure you want to continue?", preferredStyle: .actionSheet)
        Alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        Alert.addAction(UIAlertAction(title: "Delete my account", style: .destructive) { action in
            Auth.auth().currentUser?.delete() { error in
                if error == nil {
                    viewFunctions.giveHapticFeedback(error: false, prefers: true)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    viewFunctions.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default, view: self)
                }
            }
        })
        
        present(Alert, animated: true, completion: nil)
    }
}
