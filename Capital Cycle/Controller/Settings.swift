//
//  Settings.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/21/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreData

class Settings: UIViewController {

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var signedInSwitch: UISwitch!
    
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
        
        // Sets the "keep me signed in" switch to reflect the actual value
        if signedIn {
            signedInSwitch.isOn = true
        } else {
            signedInSwitch.isOn = false
        }
    }
    
    // MARK: Settings
    
    // Allows the user to update whether they want to stay signed in or not
    @IBAction func staySignedIn(_ sender: UISwitch) {
        if sender.isOn {
            signedIn = true
            updateContext()
        } else {
            signedIn = false
            updateContext()
        }
    }
    
    // Resets the user's password
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
                    resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in self.logOut(nil)}))
                    self.present(resetEmailSentAlert, animated: true, completion: nil)
                }
            })
        }))
        
        self.present(resetPasswordAlert, animated: true, completion: nil)
    }
    
    // Logs out the user
    @IBAction func logOut(_ sender: UIButton?) {
        do {
            try Auth.auth().signOut()
            if sender != nil {
                signedIn = false
                updateContext()
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Core Data
    
    // Updates the context with new values
    func updateContext() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let Context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Authentication")
        do {
            let fetchResults = try Context.fetch(fetchRequest)
            let isSignedIn = fetchResults.first as! NSManagedObject
            isSignedIn.setValue(signedIn, forKey: "signedIn")
            try Context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
