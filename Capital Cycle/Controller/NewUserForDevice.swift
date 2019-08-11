//
//  NewUserForDevice.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 8/11/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth

class NewUserForDevice: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // Storyboard outlets
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var userTypeLbl: UILabel!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var userTypePickerView: UIPickerView!
    // Code global vars
    var typesOfUser = ["--", "Camper", "Parent", "Counselor"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeLayout()
    }
    
    // MARK: View Setup
    
    // Formats the UI
    func customizeLayout() {
        // Formats the gradientView
        gradientViewHeight.constant = 0.15 * view.frame.height
        gradientView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.15)
        
        // Sets the gradients
        gradientView.setTwoGradientBackground(colorOne: Colors.Orange, colorTwo: Colors.Purple)
        logInBtn.setTwoGradientButton(colorOne: Colors.Orange, colorTwo: Colors.Purple, cornerRadius: 22.5)
        
        // Sets up the user type label
        userTypeLbl.isUserInteractionEnabled = true
        userTypeLbl.layer.cornerRadius = 6
        
        // Sets up the picker view
        userTypePickerView.delegate = self
        userTypePickerView.dataSource = self
    }
    
    @IBAction func showUserTypes(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        if userTypePickerView.isHidden {
            userTypePickerView.isHidden = false
        } else {
            userTypePickerView.isHidden = true
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
            userType = SignUp.UserType.none
        } else if typesOfUser[row] == "Camper" {
            userType = .camper
        } else if typesOfUser[row] == "Parent" {
            userType = .parent
        } else {
            userType = .counselor
        }
        
        userTypeLbl.text = typesOfUser[row]
        userTypePickerView.isHidden = true
    }
    
    // MARK: Log In New User
    
    @IBAction func logIn(_ sender: UIButton) {
        createUser()
        self.performSegue(withIdentifier: "logInNewUser", sender: self)
    }
    
    // MARK: Core Data
    
    // Create a core data user
    func createUser() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let Context = appDelegate.persistentContainer.viewContext
        let User = NSEntityDescription.insertNewObject(forEntityName: "User", into: Context)
        User.setValue(Auth.auth().currentUser?.email, forKey: "email")
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
