//
//  CamperInfoPage.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/21/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import MessageUI

class CamperInfoPage: UIViewController, MFMailComposeViewControllerDelegate {
    
    // MARK: Global Variables
    
    // Storyboard outlets
    @IBOutlet weak var gradientView: CustomView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var camperInfoLblYConstraint: NSLayoutConstraint!
    @IBOutlet weak var accountSettingsImgView: CustomImageView!
    @IBOutlet weak var camperScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var noConnectionView: CustomView!
    @IBOutlet weak var camperInfoView: CustomView!
    @IBOutlet weak var camperNameLbl: UILabel!
    @IBOutlet weak var parentNameLbl: UILabel!
    @IBOutlet weak var parentNumberLbl: UILabel!
    @IBOutlet weak var parentEmailLbl: UILabel!
    @IBOutlet weak var signedWaiverLbl: UILabel!
    @IBOutlet weak var notesLbl: UILabel!
    //Code global vars
    static let Instance = CamperInfoPage()
    var camperInfoRefreshControl = UIRefreshControl()
    var camperCells = [CustomButton]()
    var camperInfoViewItems = [UILabel]()
    var parentLastName: String!
    var parentPhone: Int!
    var parentEmail: String!
    var viewHeight: CGFloat!
    
    // MARK: View Instantiation
    
    // Runs when the view is loaded for the first time
    override func viewDidLoad() {
        super.viewDidLoad()
        formatUI()
        createCamperCell()
    }
    
    // Runs when the view is reloaded
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setProfileImg()
        if !Reachability.isConnectedToNetwork() {
            UIView.animate(withDuration: 0.25, animations: {
                self.noConnectionView.alpha = 1
            })
            
            viewFunctions.wait(time: 1.5, completion: {
                UIView.animate(withDuration: 0.25, animations: {
                    self.noConnectionView.alpha = 0
                })
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
        
        // Formats the account settings button
        CamperInfoPage.Instance.accountSettingsImgView = accountSettingsImgView
        setProfileImg()
        
        // Formats the refresh view
        camperInfoRefreshControl.backgroundColor = UIColor(named: "ViewColor")
        camperInfoRefreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        camperScrollView.refreshControl = camperInfoRefreshControl
        
        // Sets the height of a fixed form view
        viewHeight = contentView.frame.height
        
        // Formats the camper info view
        camperInfoView.alpha = 0
    }
    
    // Gets a parent's last name
    func getLastName(name: String) -> String {
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
    func formatPhoneNumber(number: String) -> Int? {
        let characters = Array("() -")
        var formattedNumber = ""
        for character in number {
            if !characters.contains(character) {
                formattedNumber.append(character)
            }
        }
        
        return Int(formattedNumber)
    }
    
    // Sets the profile image on the account settings button
    func setProfileImg() {
        accountSettingsImgView.image = user.profileImg
    }
    
    // MARK: View Management
        
    // Calls the parent's phone number
    @IBAction func callNumber(_ sender: Any) {
        if let phoneNumber = parentPhone {
            if let url = URL(string: "tel://\(phoneNumber))"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
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
    
    // Presents Google Sheet data in an array of buttons
    func createCamperCell() {
        for camper in 0..<camperInfo.count {
            let camperCell: CustomButton
            if camper == 0 {
                camperCell = CustomButton(frame: CGRect(x: 16, y: 8, width: view.frame.width - 32, height: 40))
            } else {
                camperCell = CustomButton(frame: CGRect(x: 16, y: camperCells[camper - 1].frame.maxY + 12, width: view.frame.width - 32, height: 40))
            }
            
            camperCell.setTitle("\(camperInfo[camper][0])", for: .normal)
            camperCell.setTitleColor(UIColor(named: "LabelColor"), for: .normal)
            camperCell.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
            camperCell.addTarget(self, action: #selector(displayCamperInfo(_:)), for: .touchUpInside)
            camperCell.cornerRadius = 10
            camperCell.gradientColorOne = UIColor(named: "DarkPurple")!
            camperCell.gradientColorTwo = UIColor(named: "LightPurple")!
            contentView.addSubview(camperCell)
            camperCells.append(camperCell)
        }
        
        contentViewHeight.constant = CGFloat(camperCells.count * 52) + 25
    }
    
    // Displays the camper information when a camper's name is clicked
    @objc func displayCamperInfo(_ sender: CustomButton) {
        sender.isHidden = true
        viewFunctions.giveHapticFeedback(error: false, prefers: user.prefersHapticFeedback)
        camperInfoViewItems = [camperNameLbl, parentNameLbl, parentNumberLbl, parentEmailLbl, signedWaiverLbl, notesLbl]
        for index in 0 ..< 6 {
            camperInfoViewItems[index].text = "\(camperInfo[camperCells.firstIndex(of: sender)!][index])"
        }
        
        parentLastName = getLastName(name: parentNameLbl.text!)
        parentPhone = formatPhoneNumber(number: "\(camperInfo[camperCells.firstIndex(of: sender)!][2])")
        parentEmail = "\(camperInfo[camperCells.firstIndex(of: sender)!][3])"
        let visibleRect = camperScrollView.convert(camperScrollView.bounds, to: contentView)
        let placeholderView = UIView(frame: CGRect(x: 8, y: sender.frame.maxY - 20, width: view.frame.width - 16, height: 40))
        placeholderView.backgroundColor = #colorLiteral(red: 0.3019607843, green: 0.1450980392, blue: 0.3294117647, alpha: 1)
        placeholderView.layer.cornerRadius = 20
        contentView.addSubview(placeholderView)
        var frame = placeholderView.frame
        frame = CGRect(x: 8, y: visibleRect.minY, width: view.frame.width - 16, height: 40)
        frame.size = CGSize(width: view.frame.width - 16, height: viewHeight)
        UIView.animate(withDuration: 0.5, animations: {
            placeholderView.frame = frame
        }, completion: { success in
            UIView.animate(withDuration: 0.25, animations: {
                self.camperInfoView.alpha = 1
            }, completion: { success in
                placeholderView.removeFromSuperview()
                sender.isHidden = false
            })
        })
    }
    
    // Refreshes the camper info
    @objc func updateData(_ sender: UIRefreshControl) {
        if Reachability.isConnectedToNetwork() {
            googleFunctions.refreshAccessToken() { error in
                DispatchQueue.main.async {
                    if error == nil {
                        for cell in 0 ..< self.camperCells.count {
                            self.camperCells[cell].setTitle("\(camperInfo[cell][0])", for: .normal)
                        }
                    } else {
                        print(error!)
                    }
                    
                    sender.endRefreshing()
                }
            }
        } else {
            viewFunctions.wait(time: 1.0, completion: {
                sender.endRefreshing()
            })
        }
    }
    
    // MARK: Dismiss
    
    // Dismsisses the camper info view
    @IBAction func dismissCamperInfoView(_ sender: UIButton) {
        camperInfoView.alpha = 0
        camperScrollView.isUserInteractionEnabled = true
    }
    
    // Dismisses the mail controller
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
