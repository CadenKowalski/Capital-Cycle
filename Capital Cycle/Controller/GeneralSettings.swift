//
//  GeneralSettings.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/21/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth
import FirebaseFirestore

class GeneralSettings: UIViewController {

    // Storyboard outlets
    @IBOutlet weak var gradientView: CustomView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var signedInSwitch: UISwitch!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var hapticFeedbackSwitch: UISwitch!
    // Code global vars
    let databaseRef = Firestore.firestore().collection("Users")
    
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

        // Sets the switches to reflect their actual values
        signedInSwitch.isOn = user.signedIn!
        hapticFeedbackSwitch.isOn = user.prefersHapticFeedback!
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
    
    // MARK: Settings
    
    // Allows the user to update whether they want to stay signed in or not
    @IBAction func staySignedIn(_ sender: UISwitch) {
        if sender.isOn {
            user.signedIn = true
        } else {
            user.signedIn = false
        }
        
        updateUser(email: (Auth.auth().currentUser?.email)!, key: "signedIn")
    }
    
    // Allows the user to update whether they want to receive notifications or not
    @IBAction func receiveNotifications(_ sender: UISwitch) {
    }
    
    // Allows the user to decide whether they want to get haptic feedback or not
    @IBAction func hapticVibration(_ sender: UISwitch) {
        if sender.isOn {
            user.prefersHapticFeedback = true
        } else {
            user.prefersHapticFeedback = false
        }
        
        updateContext()
    }
    
    // MARK: Core Data
        
    // Updates the context with new values
        func updateContext() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let Context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
            do {
                let fetchResults = try Context.fetch(fetchRequest)
                let Settings = fetchResults.first as! NSManagedObject
                Settings.setValue(user.prefersHapticFeedback, forKey: "hapticFeedback")
                try Context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    
    // MARK: Firebase

    func updateUser(email: String, key: String) {
        databaseRef.document(email).updateData([key: user.signedIn!]) { error in
            if error != nil {
                self.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default)
            }
        }
    }
}
