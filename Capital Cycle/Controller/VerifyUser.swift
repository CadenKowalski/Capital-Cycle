//
//  VerifyUser.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 8/4/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import Firebase

class VerifyUser: UIViewController {

    // Storyboard outlets
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    // Global code vars
    let databaseRef = Firestore.firestore().collection("Users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeLayout()
    }
    
    // MARK: View Setup / Management
    
    // Formats the UI
    func customizeLayout() {
        // Formats the gradient view
        gradientViewHeight.constant = 0.15 * view.frame.height
        gradientView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.15)
        
        // Sets the gradients
        gradientView.setTwoGradientBackground()
    }
    
    // Shows an alert
    func showAlert(title: String, message: String, actionTitle: String, actionStyle: UIAlertAction.Style) {
        let Alert = UIAlertController(title: title, message:  message, preferredStyle: .alert)
        Alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
        present(Alert, animated: true, completion: nil)
    }
    
    // Checks if the user has verified their email
    @IBAction func checkForVerifiedUser(_ sender: UIButton) {
        Auth.auth().currentUser?.reload(completion: { (Action) in
            if Auth.auth().currentUser!.isEmailVerified {
                self.uploadUser(email: (Auth.auth().currentUser?.email)!)
                self.performSegue(withIdentifier: "verifiedUser", sender: nil)
            } else {
                self.showAlert(title: "Uh oh", message: "It looks like you haven't verified your email yet", actionTitle: "OK", actionStyle: .default)
            }
        })
    }
    
    // MARK: Firebase
    
    // Uploads a user to the Firebase Firestore
    func uploadUser(email: String) {
        var userTypeString: String
        switch userType {
        case .camper:
            userTypeString = "Camper"
        case .parent:
            userTypeString = "Parent"
        default:
            return
        }
        
        databaseRef.document(email).setData(["Email": email, "Type": userTypeString, "signedIn": signedIn!]) { error in
            if error != nil {
                self.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default)
            }
        }
    }
}
