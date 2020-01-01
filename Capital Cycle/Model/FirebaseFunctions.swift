//
//  FirebaseFunctions.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 12/29/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import Firebase

struct FirebaseFunctions {
    
    // MARK: Global Variables
    
    // Code global vars
    let values: [String: Any] = ["email": user.email, "type": user.type, "signedIn": user.signedIn, "profileImgUrl": user.profileImgUrl, "prefersNotifications": user.prefersNotifications, "prefersHapticFeedback": user.prefersHapticFeedback]
    
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
                databaseRef.document(user.email!).setData(["email": user.email!, "type": userType, "signedIn": user.signedIn!, "profileImgUrl": user.profileImgUrl!, "prefersNotifications": user.prefersNotifications!, "prefersHapticFeedback": user.prefersHapticFeedback!]) { error in
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
    func updateUserData(updateValue: String, completion: @escaping(String?) -> Void) {
        switch updateValue {
            case "type":
                let userType = self.stringFromUserType()
                databaseRef.document(user.email!).updateData(["userType": userType]) { error in
                    if error == nil {
                        completion(nil)
                    } else {
                        completion(error!.localizedDescription)
                    }
                }
                
            case "profileImgUrl":
                getProfileImgUrl() { error in
                    if error == nil {
                        databaseRef.document(user.email!).updateData(["profileImgUrl": user.profileImgUrl!]) { error in
                            if error == nil {
                                completion(nil)
                            } else {
                                completion(error!.localizedDescription)
                            }
                        }
                    } else {
                        completion(error!)
                    }
                }
                
            default:
                databaseRef.document(user.email!).updateData([updateValue: values[updateValue]!]) { error in
                    if error == nil {
                        completion(nil)
                    } else {
                        completion(error!.localizedDescription)
                    }
                }
                
                completion(nil)
        }
    }
    
    // Fetches the user's Firebase Firestore data
    func fetchUserData(fetchValue: String, completion: @escaping(String?) -> Void) {
        let userRef = databaseRef.document(user.email!)
        switch fetchValue {
            case "type":
                userRef.getDocument() { (document, error) in
                    if error == nil {
                        user.type = self.userTypeFromString(userTypeString: document?.get("type") as! String)
                    } else {
                        completion(error!.localizedDescription)
                    }
                    
                    completion(nil)
                }
                
            case "all":
                userRef.getDocument() { (document, error) in
                if error == nil {
                    user.email = document?.get("email") as? String
                    user.signedIn = document?.get("signedIn") as? Bool
                    user.profileImgUrl = document?.get("profileImgUrl") as? String
                    user.prefersNotifications = document?.get("prefersNotifications") as? Bool
                    user.prefersHapticFeedback = document?.get("prefersHapticFeedback") as? Bool
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
                
            default:
            break
    }
        
        userRef.getDocument() { (document, error) in
            if error == nil {
                user.email = document?.get("email") as? String
                user.signedIn = document?.get("signedIn") as? Bool
                user.profileImgUrl = document?.get("profileImgUrl") as? String
                user.prefersNotifications = document?.get("prefersNotifications") as? Bool
                user.prefersHapticFeedback = document?.get("prefersHapticFeedback") as? Bool
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
    func logOut(completion: @escaping(String?) -> ()) {
        user.signedIn = false
        do {
            try Auth.auth().signOut()
            updateUserData(updateValue: "signedIn") { error in
                if error == nil {
                    user.reset()
                    completion(nil)
                } else {
                    completion(error!)
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
        print("Function Called")
        Auth.auth().currentUser?.delete() { error in
            if error == nil {
                print("User deleted")
                databaseRef.document(user.email!).delete() { error in
                    if error == nil {
                        print("User data deleted")
                        if user.profileImgUrl! != "Default" {
                            let storageReference = Storage.storage().reference().child("User: \(String(describing: user.uid!))/Profile Image")
                            storageReference.delete() { error in
                                if error == nil {
                                    print("User profile pic deleted")
                                    user.reset()
                                    completion(nil)
                                } else {
                                    print("Profile picture could not be deleted")
                                    completion(error!.localizedDescription)
                                }
                            }
                        } else {
                            user.reset()
                            completion(nil)
                        }
                    } else {
                        print("User data could not be deleted")
                        completion(error!.localizedDescription)
                    }
                }
            } else {
                print("User could not be deleted")
                completion(error!.localizedDescription)
            }
        }
    }
}
