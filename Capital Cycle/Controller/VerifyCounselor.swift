//
//  VerifyCounselor.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 8/4/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth

class VerifyCounselor: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var counselorIdTxtField: UITextField!
    
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
        
        // Sets up the text field
        counselorIdTxtField.delegate = self
        counselorIdTxtField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        if counselorIdTxtField.text == "082404" {
            Auth.auth().createUser(withEmail: SignUp.Instance.counselorEmail, password: SignUp.Instance.counselorPass) { (user, error) in
                if error == nil {
                    self.performSegue(withIdentifier: "VerifiedCounselor", sender: nil)
                    self.createUser(email: (Auth.auth().currentUser?.email)!)
                } else {
                    let Alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let Action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    Alert.addAction(Action)
                    self.present(Alert, animated: true, completion: nil)
                }
            }
        } else {
            counselorIdTxtField.backgroundColor = .red
            counselorIdTxtField.alpha = 0.5
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
        case .admin:
            User.setValue("Admin", forKey: "type")
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
}
