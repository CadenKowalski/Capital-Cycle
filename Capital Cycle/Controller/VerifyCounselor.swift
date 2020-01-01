//
//  VerifyCounselor.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 8/4/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import Firebase

class VerifyCounselor: UIViewController, UITextFieldDelegate, UIAdaptivePresentationControllerDelegate {
    
    // MARK: Global Variables
    
    // Storyboard outlets
    @IBOutlet weak var gradientView: CustomView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var counselorIdTxtField: UITextField!
    @IBOutlet weak var signUpBtn: CustomButton!
    @IBOutlet weak var signUpBtnProgressWheel: UIActivityIndicatorView!
    
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
        
        // Formats the text field
        counselorIdTxtField.delegate = self
        counselorIdTxtField.attributedPlaceholder = NSAttributedString(string: "Counselor ID", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
        
        // Prevents the user from dismissing the view without deleting their account
        isModalInPresentation = true
    }
    
    // MARK: Sign Up
    
    // Signs up the user
    @IBAction func signUp(_ sender: CustomButton) {
        if counselorIdTxtField.text == "082404" {
            firebaseFunctions.fetchUserData(fetchValue: "all") { error in
                if error == nil {
                    self.performSegue(withIdentifier: "VerifiedCounselor", sender: nil)
                } else {
                    viewFunctions.showAlert(title: "Error", message: error!, actionTitle: "OK", actionStyle: .default, view: self)
                }
            }
        } else {
            counselorIdTxtField.backgroundColor = .red
            counselorIdTxtField.alpha = 0.5
        }
    }
    
    // MARK: Dismiss
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let Alert = UIAlertController(title: nil, message: "This action will delete your account. Are you sure you want to continue?", preferredStyle: .actionSheet)
        Alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        Alert.addAction(UIAlertAction(title: "Delete my account", style: .destructive) { action in
            firebaseFunctions.deleteAccount()  { error in
                if error == nil {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    viewFunctions.showAlert(title: "Error", message: error!, actionTitle: "OK", actionStyle: .default, view: self)
                }
            }
        })
        
        present(Alert, animated: true, completion: nil)
    }
}
