//
//  LogIn.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/20/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import SwiftUI
import FirebaseAuth
import CryptoKit
import FirebaseFirestore
import AuthenticationServices

class LogIn: UIViewController, UITextFieldDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    // Storyboard outlets
    @IBOutlet weak var gradientView: CustomView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var logInLblYConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passTxtField: UITextField!
    @IBOutlet weak var signedInBtn: UIButton!
    @IBOutlet weak var logInBtn: CustomButton!
    @IBOutlet weak var logInBtnProgressWheel: UIActivityIndicatorView!
    @IBOutlet weak var signUpBtn: CustomButton!
    // Code global vars
    let databaseRef = Firestore.firestore().collection("Users")
    var profileImgUrl: String!
    var currentNonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeLayout()
    }
    
    // Logs in a user automatically if they have already logged in
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Auth.auth().currentUser?.reload(completion: { (action) in
            if Auth.auth().currentUser != nil {
                self.formatProgressWheel(toShow: true)
                self.fetchUserValues(email: (Auth.auth().currentUser?.email)!) {
                    if Auth.auth().currentUser != nil && signedIn == true {
                        self.performSegue(withIdentifier: "AlreadyLoggedIn", sender: nil)
                        self.formatProgressWheel(toShow: false)
                        self.giveHapticFeedback()
                    }
                    
                    self.formatProgressWheel(toShow: false)
                }
            }
        })
    }
    
    // MARK: View Setup / Management
    
    // Formats the UI
    func customizeLayout() {
        //Formats the gradient view
        if view.frame.height < 700 {
            gradientViewHeight.constant = 0.15 * view.frame.height
            gradientView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.15)
        } else if view.frame.height >= 812 {
            logInLblYConstraint.constant = 15
        }

        // Sets up the text fields
        emailTxtField.delegate = self
        passTxtField.delegate = self
        emailTxtField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
        passTxtField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
        
        // Formats the progress wheel
        logInBtnProgressWheel.isHidden = true
        
        // Formats the Aign in with Apple button
        let appleButton = ASAuthorizationAppleIDButton()
        appleButton.addTarget(self, action: #selector(signInWithApple), for: .touchDown)
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(appleButton)
        NSLayoutConstraint.activate([
            appleButton.topAnchor.constraint(equalTo: signUpBtn.bottomAnchor, constant: 8),
            appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
        ])
    }
    
    // Keep the user signed in or not
    @IBAction func keepSignedIn(_ sender: UIButton) {
        giveHapticFeedback()
        if !signedIn {
            signedIn = true
            sender.setImage(UIImage(named: "Checked"), for: .normal)
        } else {
            signedIn = false
            sender.setImage(UIImage(named: "Unchecked"), for: .normal)
        }
    }
    
    // Initiates haptic feedback
    func giveHapticFeedback() {
        let feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator.selectionChanged()
    }
    
    // Shows an alert
    func showAlert(title: String, message: String, actionTitle: String, actionStyle: UIAlertAction.Style) {
        let Alert = UIAlertController(title: title, message:  message, preferredStyle: .alert)
        Alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
        present(Alert, animated: true, completion: nil)
        if hapticFeedback {
            let feedbackGenerator = UINotificationFeedbackGenerator()
            feedbackGenerator.prepare()
            feedbackGenerator.notificationOccurred(.error)
        }
    }
    
    // Fromats the progress wheel
    func formatProgressWheel(toShow: Bool) {
        if toShow {
            logInBtnProgressWheel.isHidden = false
            logInBtn.alpha = 0.25
            logInBtnProgressWheel.startAnimating()
        } else {
            logInBtnProgressWheel.isHidden = true
            logInBtn.alpha = 1.0
            logInBtnProgressWheel.stopAnimating()
        }
    }
    
    // MARK: Sign In With Apple
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if length == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    @objc func signInWithApple() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // MARK: Log In
    
    // Logs the user in
    @IBAction func logIn(_ sender: CustomButton) {
        formatProgressWheel(toShow: true)
        Auth.auth().signIn(withEmail: emailTxtField.text!, password: passTxtField.text!) {(user, error) in
            if error == nil {
                self.updateUser(email: (Auth.auth().currentUser?.email)!)
                self.fetchUserValues(email: (Auth.auth().currentUser?.email)!) {
                    self.performSegue(withIdentifier: "LogIn", sender: self)
                    self.formatProgressWheel(toShow: false)
                    self.giveHapticFeedback()
                }
            } else {
                self.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default)
                self.formatProgressWheel(toShow: false)
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
                        self.showAlert(title: "Reset Falied", message: "Error: \(Error!.localizedDescription)", actionTitle: "OK", actionStyle: .default)
                    } else {
                        self.showAlert(title: "Email sent successfully", message: "Check your email to reset password", actionTitle: "OK", actionStyle: .default)
                    }
                })
            }))
        
        self.present(resetPasswordAlert, animated: true, completion: nil)
    }
    
    // MARK: Firebase
    
    // Updates the users signed in value if they choose to change it when logging in
    func updateUser(email: String) {
        databaseRef.document(email).updateData(["signedIn": signedIn!]) { error in
            if error != nil {
                self.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default)
            }
        }
    }
    
    // Fetches user values from the Firebase Firestore
    func fetchUserValues(email: String, completion: @escaping() -> Void) {
        let userRef = databaseRef.document(email)
        userRef.getDocument { (document, error) in
            if error == nil {
                signedIn = document?.get("signedIn") as? Bool
                self.profileImgUrl = document?.get("profileImgUrl") as? String
                switch document?.get("type") as! String {
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
                
                profileImg = self.downloadProfileImg(withURL: self.profileImgUrl)
                completion()
            } else {
                self.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default)
                completion()
            }
        }
    }
    
    // Downloads the users profile image
    func downloadProfileImg(withURL url: String) -> UIImage {
        let url = URL(string: url)!
        let data = (try? Data(contentsOf: url))
        return UIImage(data: data!)!
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
    
    // MARK: Extensions
    
    // Creates a Firebase User from data
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                } else {
                    OneMoreStep.Instance.signUpEmail = appleIDCredential.email
                    self.performSegue(withIdentifier: "SignUpFromApple", sender: nil)
                }
            }
        }
    }
    
    // Function to print message if authorization through controller fails on user end
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Something bad happened", error)
    }
    
    // Function for authorization controller presenttion context delegate
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
