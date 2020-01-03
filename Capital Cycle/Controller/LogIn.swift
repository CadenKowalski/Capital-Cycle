//
//  LogIn.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/20/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import Firebase
import CryptoKit
import AuthenticationServices

class LogIn: UIViewController, UITextFieldDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    // MARK: Global Variables
    
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
    var currentNonce: String?
    
    // MARK: View Instantiation

    // Runs when the view is loaded for the first time
    override func viewDidLoad() {
        super.viewDidLoad()
        formatUI()
    }
    
    // Logs in the user automatically if they are signedIn
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Auth.auth().currentUser?.reload() { action in
            if Auth.auth().currentUser != nil {
                viewFunctions.formatProgressWheel(progressWheel: self.logInBtnProgressWheel, button: self.logInBtn, toShow: true)
                user.email = Auth.auth().currentUser!.email!
                firebaseFunctions.fetchUserData(fetchValue: "all") { error in
                    if error == nil {
                        if (Auth.auth().currentUser!.isEmailVerified || user.isCounselorVerified!) && user.signedIn {
                            viewFunctions.giveHapticFeedback(error: false)
                            self.performSegue(withIdentifier: "AlreadyLoggedIn", sender: nil)
                            viewFunctions.formatProgressWheel(progressWheel: self.logInBtnProgressWheel, button: self.logInBtn, toShow: false)
                        }
                    } else {
                        viewFunctions.showAlert(title: "Error", message: error!, actionTitle: "OK", actionStyle: .default, view: self)
                    }
                    
                    viewFunctions.formatProgressWheel(progressWheel: self.logInBtnProgressWheel, button: self.logInBtn, toShow: false)
                }
            }
        }
    }
    
    // MARK: View Formatting
    
    // Formats the UI
    func formatUI() {
        // Formats the gradient view
        if view.frame.height < 700 {
            gradientViewHeight.constant = 0.15 * view.frame.height
            gradientView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.15)
        } else if view.frame.height >= 812 {
            logInLblYConstraint.constant = 15
        }
        
        // Formats the text fields
        emailTxtField.delegate = self
        passTxtField.delegate = self
        emailTxtField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
        passTxtField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
        
        // Formats the progress wheel
        logInBtnProgressWheel.isHidden = true
        
        // Formats the Sign in with Apple button
        let appleButton = ASAuthorizationAppleIDButton()
        appleButton.addTarget(self, action: #selector(signInWithApple), for: .touchDown)
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(appleButton)
        NSLayoutConstraint.activate([
            appleButton.heightAnchor.constraint(equalToConstant: 32.5),
            appleButton.topAnchor.constraint(equalTo: signUpBtn.bottomAnchor, constant: 8),
            appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
        ])
    }
    
    // MARK: Log In
    
    // Logs in the user
    @IBAction func logIn(_ sender: CustomButton) {
        viewFunctions.formatProgressWheel(progressWheel: logInBtnProgressWheel, button: logInBtn, toShow: true)
        user.email = emailTxtField.text!
        firebaseFunctions.fetchUserData(fetchValue: "all") { error in
            if error == nil {
                if user.type == .counselor {
                    if user.isCounselorVerified {
                        Auth.auth().signIn(withEmail: user.email, password: self.passTxtField.text!) { (authUser, error) in
                            if error == nil {
                                user.uid = Auth.auth().currentUser!.uid
                                self.performSegue(withIdentifier: "LogIn", sender: nil)
                                self.emailTxtField.text = ""
                                self.passTxtField.text = ""
                            } else {
                                viewFunctions.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default, view: self)
                            }
                            
                            viewFunctions.formatProgressWheel(progressWheel: self.logInBtnProgressWheel, button: self.logInBtn, toShow: false)
                        }
                    }
                } else {
                    Auth.auth().signIn(withEmail: user.email, password: self.passTxtField.text!) { (authUser, error) in
                        if error == nil {
                            user.uid = Auth.auth().currentUser!.uid
                            if Auth.auth().currentUser!.isEmailVerified || user.type == .admin {
                                self.performSegue(withIdentifier: "LogIn", sender: nil)
                            } else {
                                self.performSegue(withIdentifier: "UserNotVerifiedYet", sender: nil)
                            }
                            
                            self.emailTxtField.text = ""
                            self.passTxtField.text = ""
                            viewFunctions.formatProgressWheel(progressWheel: self.logInBtnProgressWheel, button: self.logInBtn, toShow: false)
                        } else {
                            viewFunctions.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default, view: self)
                            viewFunctions.formatProgressWheel(progressWheel: self.logInBtnProgressWheel, button: self.logInBtn, toShow: false)
                        }
                    }
                }
            } else {
                viewFunctions.showAlert(title: "Error", message: error!, actionTitle: "OK", actionStyle: .default, view: self)
                viewFunctions.formatProgressWheel(progressWheel: self.logInBtnProgressWheel, button: self.logInBtn, toShow: false)
            }
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
            firebaseFunctions.resetPassword(recoveryEmail: (resetPasswordAlert.textFields?.first!.text)!) { error in
                if error != nil {
                    print("Could not reset password")
                }
            }
        }))
        
        self.present(resetPasswordAlert, animated: true, completion: nil)
    }
    
    // MARK: Sign In With Apple
    
    // Generates a random string of characters
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
    
    // Encrypts a string of characters
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // Presents the Sign in with Apple view
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
    
    // Creates a Firebase user via Sign in with Apple
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let nonce = currentNonce
            guard let appleIDToken = appleIDCredential.identityToken else {
                viewFunctions.showAlert(title: "Error", message: "Authentication Failed", actionTitle: "OK", actionStyle: .default, view: self)
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                viewFunctions.showAlert(title: "Error", message: "Authentication Failed", actionTitle: "OK", actionStyle: .default, view: self)
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if error == nil {
                    user.email = appleIDCredential.email!
                    self.performSegue(withIdentifier: "SignUpFromApple", sender: nil)
                } else {
                    viewFunctions.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default, view: self)
                    return
                }
            }
        }
    }
    
    // Returns the window on which the Sign in with Apple view is presented
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    // Called when authentication fails on the user end
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error: \(error)")
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
}
