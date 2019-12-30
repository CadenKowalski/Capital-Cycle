//
//  FirebaseFunctions.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 12/29/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import Firebase

class FirebaseFunctions {
    
    // MARK: Firebase Functions
    
    // Returns the user's type as a string
    func stringFromUserType() -> String {
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
    func createUser(completion: @escaping(String?) -> Void) {
        Auth.auth().createUser(withEmail: user.email!, password: user.password!) { (_, error) in
            if error == nil {
                user.uid = Auth.auth().currentUser!.uid
                self.getProfileImgUrl { error in
                    if error == nil {
                        completion(nil)
                    } else {
                        completion(error)
                    }
                }
            } else {
                completion(error!.localizedDescription)
            }
        }
    }
    
    // Downloads the user's profile image
    func downloadProfileImg(withURL url: String) -> UIImage {
        let url = URL(string: url)!
        let data = (try? Data(contentsOf: url))
        return UIImage(data: data!)!
    }
    
    // Fetches the image url from the users selected profile image
    func getProfileImgUrl(completion: @escaping(String?) -> Void) {
        if user.profileImg == UIImage(systemName: "person.circle") {
            user.profileImgUrl = "Default"
            completion(nil)
            return
        }
        
        let imageData = user.profileImg!.jpegData(compressionQuality: 1.0)!
        let storageReference = Storage.storage().reference().child("User: \(String(describing: user.uid!))/Profile Image")
        storageReference.putData(imageData, metadata: nil) { (metaData, error) in
            if error == nil {
                storageReference.downloadURL() { (url, error) in
                    if error == nil {
                        let urlString = url?.absoluteString
                        user.profileImgUrl = urlString
                        completion(nil)
                    } else {
                        completion(error!.localizedDescription)
                    }
                }
            } else {
                completion(error!.localizedDescription)
            }
        }
    }
    
    // Uploads the user's data to Firebase Firestore
    func uploadUserData(completion: @escaping(String?) -> Void) {
        getProfileImgUrl() { error in
            if error == nil {
                let userType = self.stringFromUserType()
                databaseRef.document(user.email!).setData(["email": user.email!, "type": userType, "signedIn": user.signedIn!, "profileImgUrl": user.profileImgUrl!, "prefersNotifications": user.prefersNotifications!]) { error in
                    if error == nil {
                        completion(nil)
                    } else {
                        completion(error!.localizedDescription)
                    }
                }
            } else {
                completion(error)
            }
        }
    }
    
    // Updates the user's Firebase Firestore data
    func updateUserData(completion: @escaping(String?) -> Void) {
        getProfileImgUrl() { error in
            if error == nil {
                let userType = self.stringFromUserType()
                databaseRef.document(user.email!).updateData(["signedIn": user.signedIn!, "type": userType, "profileImgUrl": user.profileImgUrl!, "prefersNotifications": user.prefersNotifications!]) { error in
                    if error == nil {
                        completion(nil)
                    } else {
                        completion(error!.localizedDescription)
                    }
                }
                
                completion(nil)
            } else {
                completion(error)
            }
        }
    }
    
    // Fetches the user's Firebase Firestore data
    func fetchUserData(completion: @escaping(String?) -> Void) {
        let userRef = databaseRef.document(user.email!)
        userRef.getDocument() { (document, error) in
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
                
                completion(nil)
            } else {
                completion(error!.localizedDescription)
            }
        }
    }
    
    // Logs out the user
    func logOut(_ sender: UIButton?, completion: @escaping(String?) -> ()) {
        user.signedIn = false
        let storageReference = Storage.storage().reference().child("User: \(String(describing: user.uid!))/Profile Image")
        do {
            if sender == nil {
                Auth.auth().currentUser?.delete() { error in
                    if error == nil {
                        databaseRef.document(user.email!).delete() { error in
                            if error == nil {
                                if user.profileImgUrl! != "Default" {
                                    storageReference.delete() { error in
                                        if error == nil {
                                            completion(nil)
                                        } else {
                                            completion(error!.localizedDescription)
                                        }
                                    }
                                } else {
                                    completion(nil)
                                }
                            } else {
                                completion(error!.localizedDescription)
                            }
                        }
                    } else {
                        completion(error!.localizedDescription)
                    }
                }
            } else {
                try Auth.auth().signOut()
                updateUserData() { error in
                    if error == nil {
                        completion(nil)
                    } else {
                        completion(error!)
                    }
                }
            }
        } catch let error as NSError {
            completion(error.localizedDescription)
        }
    }
    
    // Resets the user's password
    func resetPassword(recoveryEmail: String, completion: @escaping(String?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: recoveryEmail) { error in
            if error == nil {
                completion(nil)
            } else {
                completion(error!.localizedDescription)
            }
        }
    }
    
    // Deletes the user's account
    func deleteAccount(completion: @escaping(String?) -> Void) {
        logOut(nil) { error in
            if error == nil {
                completion(nil)
            } else {
                completion(error)
            }
        }
    }
}
