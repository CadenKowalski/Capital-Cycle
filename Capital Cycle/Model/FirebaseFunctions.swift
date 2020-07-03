//
//  FirebaseFunctions.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 12/29/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import Firebase

struct FirebaseFunctions {
    
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
    func createUser(password: String, completion: @escaping(String?) -> Void) {
        Auth.auth().createUser(withEmail: user.email!, password: password) { (_, error) in
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
    
    // Manages the user's Firestore data
    func manageUserData(dataValues: [String], newUser: Bool, completion: @escaping(String?) -> Void) {
        if newUser {
            collectionRef.document(user.email!).setData(["email": user.email!])
        }
        
        let values: [String: Any] = ["type": user.type!, "signedIn": user.signedIn!, "profileImgUrl": user.profileImgUrl!, "prefersNotifications": user.prefersNotifications!, "prefersHapticFeedback": user.prefersHapticFeedback!, "isCounselorVerified": user.isCounselorVerified!, "isGoogleVerified": user.isGoogleVerified!,  "authenticationMethod": user.authenticationMethod!]
        for value in dataValues {
            switch value {
            case "type":
                let userType = self.stringFromUserType()
                collectionRef.document(user.email!).updateData(["type": userType]) { error in
                    if error == nil {
                        completion(nil)
                    } else {
                        completion(error!.localizedDescription)
                    }
                }
                
            case "profileImgUrl":
                getProfileImgUrl() { error in
                    if error == nil {
                        collectionRef.document(user.email!).updateData(["profileImgUrl": user.profileImgUrl!]) { error in
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
                
            case "all":
                getProfileImgUrl() { error in
                    if error == nil {
                        let userType = self.stringFromUserType()
                        for element in values {
                            if element.key == "type" {
                                collectionRef.document(user.email!).updateData(["type": userType]) { error in
                                    if error != nil {
                                        completion(error!.localizedDescription)
                                    }
                                }
                            } else if element.key == "profileImgUrl" {
                                collectionRef.document(user.email!).updateData(["profileImgUrl": user.profileImgUrl!]) { error in
                                    if error != nil {
                                        completion(error!.localizedDescription)
                                    }
                                }
                            } else {
                                collectionRef.document(user.email!).updateData([element.key: element.value]) { error in
                                    if error == nil {
                                        completion(nil)
                                    } else {
                                        completion(error!.localizedDescription)
                                    }
                                }
                            }
                        }
                    } else {
                        completion(error!)
                    }
                }
                
            default:
                collectionRef.document(user.email!).updateData([value: values[value]!]) { error in
                    if error == nil {
                        completion(nil)
                    } else {
                        completion(error!.localizedDescription)
                    }
                }
            }
        }
    }
    
     // Fetches the user's Firebase Firestore data
    func fetchUserData(fetchValue: String, completion: @escaping(String?) -> Void) {
        let documentRef = collectionRef.document(user.email!)
        switch fetchValue {
            case "type":
                documentRef.getDocument() { (document, error) in
                    if error == nil {
                        user.type = self.userTypeFromString(userTypeString: document?.get("type") as! String)
                        completion(nil)
                    } else {
                        completion(error!.localizedDescription)
                    }
                }
                
            case "all":
                documentRef.getDocument() { (document, error) in
                    if error == nil {
                        if document?.get("email") as? String != nil {
                            user.signedIn = document?.get("signedIn") as? Bool
                            user.profileImgUrl = document?.get("profileImgUrl") as? String
                            user.prefersNotifications = document?.get("prefersNotifications") as? Bool
                            user.prefersHapticFeedback = document?.get("prefersHapticFeedback") as? Bool
                            user.isCounselorVerified = document?.get("isCounselorVerified") as? Bool
                            user.isGoogleVerified = document?.get("isGoogleVerified") as? Bool
                            user.authenticationMethod = document?.get("authenticationMethod") as? String
                            user.type = self.userTypeFromString(userTypeString: document?.get("type") as! String)
                            if user.profileImgUrl == "Default" {
                                user.profileImg = UIImage(systemName: "person.circle")
                            } else {
                                user.profileImg = self.downloadProfileImg(withURL: user.profileImgUrl!)
                            }
                            
                            completion(nil)
                        } else {
                            completion(nil)
                        }
                    } else {
                        completion(error!.localizedDescription)
                    }
                }
                
            default:
                break
            }
    }
    
    // Logs out the user
    func logOut(completion: @escaping(String?) -> Void) {
        user.signedIn = false
        manageUserData(dataValues: ["signedIn"], newUser: false) { error in
            if error == nil {
                signOutAuthUser() { error in
                    if error == nil {
                        user.reset()
                        completion(nil)
                    } else {
                        completion(error)
                    }
                }
            } else {
                completion(error!)
            }
        }
    }
    
    // Signs out the Auth user
    func signOutAuthUser(completion: @escaping(String?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error as NSError{
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
        Auth.auth().currentUser?.delete() { error in
            if error == nil {
                collectionRef.document(user.email!).delete() { error in
                    if error == nil {
                        if user.profileImgUrl! != "Default" {
                            let storageReference = Storage.storage().reference().child("User: \(String(describing: user.uid!))/Profile Image")
                            storageReference.delete() { error in
                                if error == nil {
                                    user.reset()
                                    completion(nil)
                                } else {
                                    completion(error!.localizedDescription)
                                }
                            }
                        } else {
                            user.reset()
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
    }
}
