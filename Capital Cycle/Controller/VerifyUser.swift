//
//  VerifyUser.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 8/4/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreData

class VerifyUser: UIViewController, UIAdaptivePresentationControllerDelegate {

    // Storyboard outlets
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    
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
    }
    
    @IBAction func checkForVerifiedUser(_ sender: UIButton) {
        Auth.auth().currentUser?.reload(completion: { (Action) in
            if Auth.auth().currentUser!.isEmailVerified {
                self.createUser(email: (Auth.auth().currentUser?.email)!)
                self.performSegue(withIdentifier: "verifiedUser", sender: nil)
            }
        })
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
