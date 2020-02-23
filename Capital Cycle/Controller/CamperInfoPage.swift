//
//  CamperInfoPage.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/21/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import MessageUI
import GoogleAPIClientForREST

class CamperInfoPage: UIViewController, MFMailComposeViewControllerDelegate {
    // MARK: Global Variables
    
    // Storyboard outlets
    @IBOutlet weak var gradientView: CustomView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var camperInfoLblYConstraint: NSLayoutConstraint!
    @IBOutlet weak var accountSettingsImgView: CustomImageView!
    @IBOutlet weak var camperScrollViewYConstraint: NSLayoutConstraint!
    @IBOutlet weak var camperScrollView: UIScrollView!
    @IBOutlet weak var scrollViewDisplay: UIView!
    @IBOutlet weak var scrollViewDisplayHeight: NSLayoutConstraint!
    @IBOutlet weak var noConnectionView: CustomView!
    @IBOutlet weak var camperInfoView: UIView!
    @IBOutlet weak var camperName: UILabel!
    @IBOutlet weak var parentNameLbl: UILabel!
    @IBOutlet weak var parentNumberLbl: UILabel!
    @IBOutlet weak var parentEmailLbl: UILabel!
    @IBOutlet weak var signedWaiverLbl: UILabel!
    //Code global vars
    static let Instance = CamperInfoPage()
    let spreadsheetID = "1alCW-eSX-lC6CUi0lbmNK7hpfkUhpOqhrbWZCBJgXuk"
    let Service = GTLRSheetsService()
    var camperInfoRefreshControl = UIRefreshControl()
    var camperBtns = [UIButton]()
    var parentLastName: String!
    var parentPhone: Int!
    var parentEmail: String!
    
    // MARK: View Instantiation
    
    // Runs when the view is loaded for the first time
    override func viewDidLoad() {
        super.viewDidLoad()
        formatUI()
        createBtn()
    }
    
    // Runs when the view is reloaded
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setProfileImg()
        if !Reachability.isConnectedToNetwork() {
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.noConnectionView.alpha = 1})
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.noConnectionView.alpha = 0})
            })
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
            camperInfoLblYConstraint.constant = 15
        }

        // Formats the Y constraints relative to the gradient view height
        camperScrollViewYConstraint.constant = gradientView.frame.height + 10
        
        // Formats the account settings button
        CamperInfoPage.Instance.accountSettingsImgView = accountSettingsImgView
        setProfileImg()
        
        // Formats the refresh view
        camperInfoRefreshControl.backgroundColor = UIColor(named: "ViewColor")
        camperInfoRefreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        camperScrollView.refreshControl = camperInfoRefreshControl
    }
    
    // Formats a parents name
    func formatParentName(name: String) -> String {
        var lastName = ""
        var start = false
        for character in name {
            if !start {
                if character == " " {
                    start = true
                }
            } else {
                lastName.append(character)
            }
        }
        return lastName
    }
    
    // Formats a phone number so that the app can call it
    func formatPhoneNumber(number: String) -> Int {
        let characters = Array("() -")
        var formattedNumber = ""
        for character in number {
            if !characters.contains(character) {
                formattedNumber.append(character)
            }
        }
        
        return Int(formattedNumber)!
    }
    
    // Sets the profile image on the account settings button
    func setProfileImg() {
        accountSettingsImgView.image = user.profileImg
    }
    
    // MARK: View Management
        
    // Calls the parent's phone number
    @IBAction func callNumber(_ sender: Any) {
        if let url = URL(string: "tel://\(parentPhone!))"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    // Composes an email to a parent
    @IBAction func sendEmail(_ sender: Any) {
        let Alert = UIAlertController(title: nil, message:  nil, preferredStyle: .actionSheet)
        Alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        Alert.addAction(UIAlertAction(title: "Email \(parentEmail!)", style: .default, handler: { error in
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["\(self.parentEmail!)"])
                mail.setSubject("A Message From Your Capital Cycle Counselors")
                mail.setMessageBody("<p>Good afternoon Mr. and Mrs. \(self.parentLastName!),<br><br>I am emailing you regarding...</p>", isHTML: true)
                self.present(mail, animated: true)
            } else {
                viewFunctions.showAlert(title: "Error", message: "Could not compose email", actionTitle: "OK", actionStyle: .default, view: self)
            }
        }))
            
        present(Alert, animated: true, completion: nil)
    }
    
    // MARK: Display Camper Info
    
    func createBtn() {
        for camper in 0..<camperInfo.count {
            let camperBtn: UIButton
            if camperBtns.count == 0 {
                camperBtn = UIButton(frame: CGRect(x: 16, y:  0, width: view.frame.width, height: 40))
            } else {
                camperBtn = UIButton(frame: CGRect(x: 16, y:  camperBtns[camper - 1].frame.maxY + 8, width: view.frame.width, height: 40))
            }
            
            camperBtn.setTitle("\(camperInfo[camper][0])", for: .normal)
            camperBtn.setTitleColor(UIColor(named: "LabelColor"), for: .normal)
            camperBtn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
            camperBtn.contentHorizontalAlignment = .left
            camperBtn.addTarget(self, action: #selector(displayCamperInfo(_:)), for: .touchUpInside)
            scrollViewDisplay.addSubview(camperBtn)
            camperBtns.append(camperBtn)
        }
        
        if (camperBtns.count * 40 + 25) > 668 {
            scrollViewDisplayHeight.constant = CGFloat(camperBtns.count * 40) + 25
        } else {
            scrollViewDisplayHeight.constant = view.frame.height - (gradientView.frame.height + 35)
        }
    }
    
    @objc func updateData(_ sender: UIRefreshControl) {
        if Reachability.isConnectedToNetwork() {
            googleFunctions.refreshAccessToken() { error in
                DispatchQueue.main.async {
                    if error == nil {
                        for button in 0..<self.camperBtns.count {
                            self.camperBtns[button].setTitle("\(camperInfo[button][0])", for: .normal)
                        }
                    } else {
                        print(error!)
                    }
                    
                    sender.endRefreshing()
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                sender.endRefreshing()
            })
        }
    }
    
    // Displays the camper information
    @objc func displayCamperInfo(_ sender: UIButton) {
        if traitCollection.userInterfaceStyle == .light {
            scrollViewDisplay.backgroundColor = #colorLiteral(red: 0.3000000119, green: 0.3000000119, blue: 0.3000000119, alpha: 1)
            camperScrollView.backgroundColor = #colorLiteral(red: 0.3000000119, green: 0.3000000119, blue: 0.3000000119, alpha: 1)
            view.backgroundColor = #colorLiteral(red: 0.3000000119, green: 0.3000000119, blue: 0.3000000119, alpha: 1)
        }
        
        camperScrollView.isUserInteractionEnabled = false
        camperInfoView.isHidden = false
        scrollViewDisplay.bringSubviewToFront(camperInfoView)
        camperName.text = "\(camperInfo[camperBtns.firstIndex(of: sender)!][0])"
        parentNameLbl.text = "\(camperInfo[camperBtns.firstIndex(of: sender)!][1])"
        parentLastName = formatParentName(name: parentNameLbl.text!)
        parentNumberLbl.text = "\(camperInfo[camperBtns.firstIndex(of: sender)!][2])"
        parentPhone = formatPhoneNumber(number: "\(camperInfo[camperBtns.firstIndex(of: sender)!][2])")
        parentEmailLbl.text = "\(camperInfo[camperBtns.firstIndex(of: sender)!][3])"
        parentEmail = "\(camperInfo[camperBtns.firstIndex(of: sender)!][3])"
        signedWaiverLbl.text = "\(camperInfo[camperBtns.firstIndex(of: sender)!][4])"
    }
    
    // MARK: Dismiss
    
    // Dismsisses the camper info view
    @IBAction func dismissCamperInfoView(_ sender: UIButton) {
        scrollViewDisplay.backgroundColor = UIColor(named: "ViewColor")
        camperScrollView.backgroundColor = UIColor(named: "ViewColor")
        view.backgroundColor = UIColor(named: "ViewColor")
        camperInfoView.isHidden = true
        camperScrollView.isUserInteractionEnabled = true
    }
    
    // Dismisses the mail controller
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
