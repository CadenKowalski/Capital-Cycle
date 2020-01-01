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
    
    // MARK: Global Variables
    
    // Storyboard outlets
    @IBOutlet weak var gradientView: CustomView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var signedInSwitch: UISwitch!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var hapticFeedbackSwitch: UISwitch!
    
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

        // Formats the settings switches
        signedInSwitch.isOn = user.signedIn!
        notificationsSwitch.isOn = user.prefersNotifications!
        hapticFeedbackSwitch.isOn = user.prefersHapticFeedback!
    }
    
    // MARK: Settings
    
    // Allows the user to update whether they want to stay signed in or not
    @IBAction func staySignedIn(_ sender: UISwitch) {
        if sender.isOn {
            user.signedIn = true
        } else {
            user.signedIn = false
        }
        
        firebaseFunctions.updateUserData(updateValue: "signedIn") { error in
            if error != nil {
                viewFunctions.showAlert(title: "Error", message: error!, actionTitle: "OK", actionStyle: .default, view: self)
            }
        }
    }
    
    // Allows the user to update whether they want to receive notifications or not
    @IBAction func receiveNotifications(_ sender: UISwitch) {
        if sender.isOn {
            user.prefersNotifications = true
        } else {
            user.prefersNotifications = false
        }
        
        firebaseFunctions.updateUserData(updateValue: "prefersNotifications") { error in
            if error != nil {
                viewFunctions.showAlert(title: "Error", message: error!, actionTitle: "OK", actionStyle: .default, view: self)
            }
        }
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
}
