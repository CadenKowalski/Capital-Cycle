//
//  FirebaseFunctions.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 12/28/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import Firebase

class FirebaseFunctions: UIViewController {
    
    // MARK: View Controllers
    
    // Generates haptic feedback
    func giveHapticFeedback(error: Bool) {
        if user.prefersHapticFeedback! {
            if error {
                let feedbackGenerator = UINotificationFeedbackGenerator()
                feedbackGenerator.prepare()
                feedbackGenerator.notificationOccurred(.error)
            } else {
                let feedbackGenerator = UISelectionFeedbackGenerator()
                feedbackGenerator.selectionChanged()
            }
        }
    }
    
    // Shows an alert
    func showAlert(title: String, message: String, actionTitle: String, actionStyle: UIAlertAction.Style) {
        let Alert = UIAlertController(title: title, message:  message, preferredStyle: .alert)
        Alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
        present(Alert, animated: true, completion: nil)
        giveHapticFeedback(error: true)
    }
    
    // Downloads the user's profile image
    func downloadProfileImg(withURL url: String) -> UIImage {
        let url = URL(string: url)!
        let data = (try? Data(contentsOf: url))
        return UIImage(data: data!)!
    }
    
    // MARK: Firebase Functions
    
    // Returns the user's type as a string
    func userTypeString() -> String {
        switch user.type {
        case .camper:
            return "Camper"
        case .parent:
            return "Parent"
        case .counselor:
            return "Counselor"
        case .admin:
            return "Admin"
        default:
            return ""
        }
    }
    
    // Returns the user's type from a string
    func userTypeFromString(userTypeString: String) -> FirebaseUser.type {
        switch userTypeString {
        case "Camper":
            return .camper
        case "Parent":
            return .parent
        case "Counselor":
            return .counselor
        case "Admin":
            return .admin
        default:
            return .none
        }
    }
    
    // Creates a Firebase user via email and password
    func CreateUser(completion: @escaping() -> Void) {
        print("True 2")
        Auth.auth().createUser(withEmail: user.email!, password: user.password!) { (_, error) in
            if error == nil {
                self.getProfileImgUrl {
                    completion()
                }
            } else {
                self.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default)
            }
        }
    }
    
    // Fetches the image url from the users selected profile image
    func getProfileImgUrl(completion: @escaping() -> Void) {
        let uid = Auth.auth().currentUser?.uid
        let storageReference = Storage.storage().reference().child("user/\(String(describing: uid))")
        let imageData = user.profileImg!.jpegData(compressionQuality: 1.0)!
        storageReference.putData(imageData, metadata: nil) { (metaData, error) in
            if error == nil {
                storageReference.downloadURL(completion: { (url, error) in
                    if error == nil {
                        let urlString = url?.absoluteString
                        user.profileImgUrl = urlString
                        completion()
                    } else {
                        self.showAlert(title: "Error", message: "Could not upload image", actionTitle: "OK", actionStyle: .default)
                    }
                })
            } else {
                self.showAlert(title: "Error", message: "Could not upload image", actionTitle: "OK", actionStyle: .default)
            }
        }
    }
    
    // Uploads the user's data to Firebase Firestore
    func uploadUserData() {
        getProfileImgUrl {
            let userType = self.userTypeString()
            if user.profileImg! == UIImage(systemName: "person.circle") {
                user.profileImgUrl = "Default"
            }

            databaseRef.document(user.email!).setData(["email": user.email!, "type": userType, "signedIn": user.signedIn!, "profileImgUrl": user.profileImgUrl!, "prefersNotifications": user.prefersNotifications!]) { error in
                if error != nil {
                    self.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default)
                }
            }
        }
    }
    
    // Updates the user's Firebase Firestore data
    func updateUserData() {
        getProfileImgUrl {
            let userType = self.userTypeString()
            databaseRef.document(user.email!).updateData(["signedIn": user.signedIn!, "type": userType, "profileImgUrl": user.profileImgUrl!, "prefersNotifications": user.prefersNotifications!]) { error in
                if error != nil {
                    self.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default)
                }
            }
        }
    }
    
    // Fetches the user's Firebase Firestore data
    func fetchUserData(completion: @escaping() -> Void) {
        let userRef = databaseRef.document(user.email!)
        userRef.getDocument { (document, error) in
            if error == nil {
                user.email = document?.get("email") as? String
                user.signedIn = document?.get("signedIn") as? Bool
                user.profileImgUrl = document?.get("profileImgUrl") as? String
                user.prefersNotifications = document?.get("prefersNotifications") as? Bool
                user.type = self.userTypeFromString(userTypeString: document?.get("type") as! String)
                if user.profileImgUrl == "Default" {
                    user.profileImg = UIImage(systemName: "person.circle")
                } else {
                    user.profileImg = self.downloadProfileImg(withURL: user.profileImgUrl!)
                }
                
                completion()
            } else {
                self.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default)
            }
        }
    }
    
    // Logs out the user
    func logOut(_ sender: UIButton?) {
        giveHapticFeedback(error: false)
        user.signedIn = false
        do {
            if sender == nil {
                let email = Auth.auth().currentUser?.email
                Auth.auth().currentUser?.delete(completion: { error in
                    if error == nil {
                        databaseRef.document(email!).delete(completion: { error in
                            if error != nil {
                                self.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default)
                            }
                        })
                    } else {
                        self.showAlert(title: "Delete Failed", message: "Error: \(error!.localizedDescription)", actionTitle: "OK", actionStyle: .default)
                    }
                })
            } else {
                updateUserData()
            }
            
            try Auth.auth().signOut()
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } catch let error as NSError {
            showAlert(title: "Error", message: error.localizedDescription, actionTitle: "OK", actionStyle: .default)
        }
    }
    
    // Resets the user's password
    func resetPassword() {
        giveHapticFeedback(error: false)
        let resetPasswordAlert = UIAlertController(title: "Reset Password", message: "Enter your email adress", preferredStyle: .alert)
        resetPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
            textField.font = UIFont(name: "Avenir-Book", size: 13.0)
        }
        
        resetPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        resetPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .destructive, handler: { (Action) in
            let userEmail = resetPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: userEmail!, completion: { error in
                if error == nil {
                    self.showAlert(title: "Email sent successfully", message: "Check your email to reset password", actionTitle: "OK", actionStyle: .default)
                } else {
                    self.showAlert(title: "Reset Failed", message: "Error: \(error!.localizedDescription)", actionTitle: "OK", actionStyle: .default)
                }
            })
        }))
        
        self.present(resetPasswordAlert, animated: true, completion: nil)
    }
    
    // Deletes the user's account
    func deleteAccount() {
        giveHapticFeedback(error: false)
        let confirmDeleteAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        confirmDeleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        confirmDeleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            self.logOut(nil)
        }))
        
        self.present(confirmDeleteAlert, animated: true, completion: nil)
    }
}
