//
//  LogIn.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/20/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import Firebase
import AuthenticationServices

class LogIn: UIViewController, UITextFieldDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    // MARK: Global Variables
    
    // Storyboard outlets
    @IBOutlet weak var gradientView: CustomView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var logInLblYConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passTxtField: UITextField!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var loginBtn: CustomButton!
    @IBOutlet weak var loginBtnProgressWheel: UIActivityIndicatorView!
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
                viewFunctions.formatProgressWheel(progressWheel: self.loginBtnProgressWheel, button: self.loginBtn, toShow: true, hapticFeedback: false)
                print(user.email!)
                user.email = Auth.auth().currentUser!.email!
                print(user.email!)
                user.uid = Auth.auth().currentUser!.uid
                firebaseFunctions.fetchUserData(fetchValue: "all") { error in
                    if error == nil {
                        if (Auth.auth().currentUser!.isEmailVerified || user.isCounselorVerified!) && user.signedIn {
                            viewFunctions.giveHapticFeedback(error: false, prefers: user.prefersHapticFeedback!)
                            self.performSegue(withIdentifier: "AlreadyLoggedIn", sender: nil)
                        }
                        
                        viewFunctions.formatProgressWheel(progressWheel: self.loginBtnProgressWheel, button: self.loginBtn, toShow: false, hapticFeedback: false)
                    } else {
                        viewFunctions.showAlert(title: "Error", message: error!, actionTitle: "OK", actionStyle: .default, view: self)
                    }
                    
                    viewFunctions.formatProgressWheel(progressWheel: self.loginBtnProgressWheel, button: self.loginBtn, toShow: false, hapticFeedback: false)
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
        loginBtnProgressWheel.isHidden = true
        
        // Formats the Continue with Apple Button
        let continueWithAppleButton: ASAuthorizationAppleIDButton
        if traitCollection.userInterfaceStyle == .light {
            continueWithAppleButton = ASAuthorizationAppleIDButton(authorizationButtonType: .continue, authorizationButtonStyle: .black)
        } else {
            continueWithAppleButton = ASAuthorizationAppleIDButton(authorizationButtonType: .continue, authorizationButtonStyle: .white)
        }
        
        continueWithAppleButton.addTarget(self, action: #selector(signInWithApple), for: .touchDown)
        continueWithAppleButton.cornerRadius = 22.5
        continueWithAppleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(continueWithAppleButton)
        NSLayoutConstraint.activate([
            continueWithAppleButton.heightAnchor.constraint(equalToConstant: 45),
            continueWithAppleButton.topAnchor.constraint(equalTo: forgotPasswordBtn.bottomAnchor, constant: 24),
            continueWithAppleButton.widthAnchor.constraint(equalToConstant: 140),
            continueWithAppleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 85)
        ])
        
        // Formats the Sign in with Apple button
        let appleButton: ASAuthorizationAppleIDButton
        if #available(iOS 13.2, *) {
            if traitCollection.userInterfaceStyle == .light {
                appleButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signUp, authorizationButtonStyle: .black)
            } else {
                appleButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signUp, authorizationButtonStyle: .white)
            }
            
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
    }
    
    // MARK: Log In
    
    @IBAction func verifyInputs() {
        if emailTxtField.text == "" {
            viewFunctions.showAlert(title: "Uh oh", message: "Please enter a valid email adress", actionTitle: "OK", actionStyle: .default, view: self)
        } else if passTxtField.text == "" {
            viewFunctions.showAlert(title: "Uh oh", message: "Please enter a valid password ", actionTitle: "OK", actionStyle: .default, view: self)
        } else {
            logIn()
        }
    }
    
    // Logs in the user
    func logIn() {
        viewFunctions.formatProgressWheel(progressWheel: loginBtnProgressWheel, button: loginBtn, toShow: true, hapticFeedback: false)
        user.email = emailTxtField.text!
        firebaseFunctions.fetchUserData(fetchValue: "all") { error in
            if error == nil {
                if user.type == .counselor {
                    Auth.auth().signIn(withEmail: user.email, password: self.passTxtField.text!) { (authUser, error) in
                        if error == nil {
                            user.uid = Auth.auth().currentUser!.uid
                            viewFunctions.giveHapticFeedback(error: false, prefers: user.prefersHapticFeedback!)
                            self.performSegue(withIdentifier: "LogIn", sender: nil)
                            self.emailTxtField.text = ""
                            self.passTxtField.text = ""
                        } else {
                            viewFunctions.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default, view: self)
                        }
                        
                        viewFunctions.formatProgressWheel(progressWheel: self.loginBtnProgressWheel, button: self.loginBtn, toShow: false, hapticFeedback: false)
                    }
                } else {
                    Auth.auth().signIn(withEmail: user.email, password: self.passTxtField.text!) { (authUser, error) in
                        if error == nil {
                            user.uid = Auth.auth().currentUser!.uid
                            viewFunctions.giveHapticFeedback(error: false, prefers: user.prefersHapticFeedback!)
                            if Auth.auth().currentUser!.isEmailVerified || user.type == .admin {
                                self.performSegue(withIdentifier: "LogIn", sender: nil)
                            } else {
                                self.performSegue(withIdentifier: "UserNotVerifiedYet", sender: nil)
                            }
                            
                            self.emailTxtField.text = ""
                            self.passTxtField.text = ""
                            viewFunctions.formatProgressWheel(progressWheel: self.loginBtnProgressWheel, button: self.loginBtn, toShow: false, hapticFeedback: false)
                        } else {
                            viewFunctions.showAlert(title: "Error", message: error!.localizedDescription, actionTitle: "OK", actionStyle: .default, view: self)
                            viewFunctions.formatProgressWheel(progressWheel: self.loginBtnProgressWheel, button: self.loginBtn, toShow: false, hapticFeedback: false)
                        }
                    }
                }
            } else {
                viewFunctions.showAlert(title: "Error", message: error!, actionTitle: "OK", actionStyle: .default, view: self)
                viewFunctions.formatProgressWheel(progressWheel: self.loginBtnProgressWheel, button: self.loginBtn, toShow: false, hapticFeedback: false)
            }
        }
    }
    
    // Resets the user's password
    @IBAction func resetPassword(_ sender: UIButton) {
        let resetPasswordAlert = UIAlertController(title: "Reset Password", message: "Enter your email adress", preferredStyle: .alert)
        resetPasswordAlert.addTextField { (textField) in
            textField.keyboardType = .emailAddress
            textField.font = UIFont(name: "Avenir-Book", size: 13.0)
            if self.traitCollection.userInterfaceStyle == .light {
                textField.attributedText = NSAttributedString(string: "\(user.email!)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
            } else {
                textField.attributedText = NSAttributedString(string: "\(user.email!)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 13)!])
            }
        }
        
        resetPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        resetPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (Action) in
            firebaseFunctions.resetPassword(recoveryEmail: (resetPasswordAlert.textFields?.first!.text)!) { error in
                if error == nil {
                    viewFunctions.showAlert(title: "Success", message: "You have been sent a password reset email", actionTitle: "OK", actionStyle: .default, view: self)
                } else {
                    print("Could not reset password")
                }
            }
        }))
        
        self.present(resetPasswordAlert, animated: true, completion: nil)
    }
    
    // MARK: Sign In With Apple
    
    // Presents the authorization controller
    @objc func signInWithApple() {
        let nonce = authenticationFunctions.randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email]
        request.requestedOperation = .operationLogin
        request.nonce = authenticationFunctions.sha256(nonce)
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
                    viewFunctions.giveHapticFeedback(error: false, prefers: true)
                    user.email = Auth.auth().currentUser!.email
                    user.uid = Auth.auth().currentUser!.uid
                    user.authenticationMethod = "Apple"
                    if appleIDCredential.email != nil {
                        self.performSegue(withIdentifier: "SignUpFromApple", sender: nil)
                    } else {
                        firebaseFunctions.fetchUserData(fetchValue: "all") { error in
                            if error == nil {
                                self.performSegue(withIdentifier: "LogIn", sender: nil)
                            } else {
                                viewFunctions.showAlert(title: "Error", message: error!, actionTitle: "OK", actionStyle: .default, view: self)
                            }
                        }
                    }
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
