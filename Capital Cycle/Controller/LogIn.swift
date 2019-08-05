//
//  LogIn.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/20/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreData

class LogIn: UIViewController, UITextFieldDelegate {

    // Storyboard outlets
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passTxtField: UITextField!
    @IBOutlet weak var signedInBtn: UIButton!
    @IBOutlet weak var logInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeLayout()
    }
    
    // Logs in a user automatically if they have already logged in
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            Auth.auth().currentUser?.reload(completion: { (Action) in
                if Auth.auth().currentUser != nil && signedIn == true {
                    self.performSegue(withIdentifier: "AlreadyLoggedIn", sender: nil)
                }
            })
        }
    }
    
    // MARK: View Setup
    
    // Formats the UI
    func customizeLayout() {
        //Formats the grdient view
        gradientViewHeight.constant = 0.15 * view.frame.height
        gradientView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.15)
        
        // Sets the gradients
        gradientView.setTwoGradientBackground(colorOne: Colors.Orange, colorTwo: Colors.Purple)
        logInBtn.setTwoGradientButton(colorOne: Colors.Orange, colorTwo: Colors.Purple, cornerRadius: 22.5)

        // Sets up the text fields
        emailTxtField.delegate = self
        passTxtField.delegate = self
        emailTxtField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
        passTxtField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])

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
    
    // MARK: Log In
    
    // Logs the user in
    @IBAction func logIn(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailTxtField.text!, password: passTxtField.text!) {(user, error) in
            if error == nil {
                if Auth.auth().currentUser!.isEmailVerified {
                    self.updateContext()
                    self.fetchValuesFromContext()
                    self.performSegue(withIdentifier: "LogIn", sender: self)
                } else {
                    self.performSegue(withIdentifier: "verifyUserLoggingIn", sender: nil)
                }
            } else {
                let Alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let Action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                Alert.addAction(Action)
                self.present(Alert, animated: true, completion: nil)
            }
        }
    }
    
    // Resets the users password
    @IBAction func resetPassword(_ sender: UIButton) {
        let resetPasswordAlert = UIAlertController(title: "Reset Password", message: "Enter your email adress", preferredStyle: .alert)
            resetPasswordAlert.addTextField { (textField) in
                textField.placeholder = "Email"
                textField.keyboardType = .emailAddress
                textField.font = UIFont(name: "Avenir-Book", size: 13.0)
            }
            
            resetPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            resetPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (Action) in
                let userEmail = resetPasswordAlert.textFields?.first?.text
                Auth.auth().sendPasswordReset(withEmail: userEmail!, completion: { (Error) in
                    if Error != nil {
                        let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: Error?.localizedDescription))", preferredStyle: .alert)
                        resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(resetFailedAlert, animated: true, completion: nil)
                    } else {
                        let resetEmailSentAlert = UIAlertController(title: "Email sent successfully", message: "Check your email", preferredStyle: .alert)
                        resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(resetEmailSentAlert, animated: true, completion: nil)
                    }
                })
            }))
        
        self.present(resetPasswordAlert, animated: true, completion: nil)
    }
    
    // MARK: Core Data
        
    // Updates the context with new values
    func updateContext() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let Context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let Users = try Context.fetch(fetchRequest) as! [NSManagedObject]
            for User in Users {
                if User.value(forKey: "email") as? String == Auth.auth().currentUser?.email {
                    User.setValue(signedIn, forKey: "signedIn")
                }
            }
            try Context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func fetchValuesFromContext() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let Context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let Users = try Context.fetch(fetchRequest) as? [NSManagedObject]
            for User in Users! {
                if User.value(forKey: "email") as? String == Auth.auth().currentUser?.email {
                    switch User.value(forKey: "type") as? String {
                    case "Camper":
                        userType = .camper
                    case "Parent":
                        userType = .parent
                    case "Counselor":
                        userType = .counselor
                    case "Admin":
                        userType = .admin
                    default:
                        return
                    }
                    
                    return
                }
            }
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    // MARK: Dismiss Keyboard
    
    // Dismiss keyboard when "done" is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // Dismiss keyboard when view tapped
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
