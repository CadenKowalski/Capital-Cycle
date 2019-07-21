//
//  PageOne.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/7/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import SafariServices

class PageOne: UIViewController {

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollViewDisplay: UIView!
    @IBOutlet weak var campDatesLbl: UILabel!
    @IBOutlet weak var campDatesYConstraint: NSLayoutConstraint!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeLayout()
    }
    
    // MARK: View Setup
    
    // Formats the UI
    func customizeLayout() {
        // Formats the gradient view
        gradientViewHeight.constant = 0.15 * view.frame.height
        gradientView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.15)
        
        // Readjusts the Y constraints
        campDatesYConstraint.constant = gradientViewHeight.constant + 8
        
        // Sets the gradients
        gradientView.setTwoGradientBackground(colorOne: Colors.Orange, colorTwo: Colors.Purple)
        signUpBtn.setTwoGradientButton(colorOne: Colors.Orange, colorTwo: Colors.Purple, cornerRadius: 30)
    }
    
    // MARK: Actions
    
    // Takes the user to the CapitalCycleCamp Facebook page
    @IBAction func Facebook(_ sender: UIButton) {
        let facebookAppURL = URL(string: "fb://profile/839679162770435")!
        if UIApplication.shared.canOpenURL(facebookAppURL) {
            UIApplication.shared.open(facebookAppURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string: "https://www.facebook.com/CapitalCycleCamp/")!, options: [:], completionHandler: nil)
        }
    }
    
    // Takes the user to the CapitalCycleCamp Instagram page
    @IBAction func Instagram(_ sender: UIButton) {
        let instagramURL = NSURL(string: "instagram://capitalcyclecamp/")! as URL
        if UIApplication.shared.canOpenURL(instagramURL as URL) {
            UIApplication.shared.open(instagramURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(NSURL(string: "https://instagram.com/capitalcyclecamp/")! as URL)
        }
    }
    
    // Takes the user to the Capital Cycle Camp sign up page
    @IBAction func SignUp(_ sender: UIButton) {
        let websiteURL = NSURL(string: "https://capitalcyclecamp.org/signup")! as URL
        let svc = SFSafariViewController(url: websiteURL)
        present(svc, animated: true, completion: nil)
    }
}
