//
//  FAQPage.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/9/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit

class FAQPage: UIViewController {

    // Storyboard outlets
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var FAQLblYConstraint: NSLayoutConstraint!
    @IBOutlet weak var accountSettingsImageView: UIImageView!
    @IBOutlet weak var scrollViewYConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeLayout()
    }
    
    // MARK: View Setup
    
    func customizeLayout() {
        // Formats the gradient view
        if view.frame.height < 700 {
            gradientViewHeight.constant = 0.15 * view.frame.height
            gradientView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.15)
        } else if view.frame.height >= 812 {
            FAQLblYConstraint.constant = 15
        }
        
        // Sets the profile image on the account settings button
        accountSettingsImageView.isUserInteractionEnabled = true
        accountSettingsImageView.layer.cornerRadius = 20
        accountSettingsImageView.image = profileImage
        
        // Readjusts the Y constraints
        scrollViewYConstraint.constant = gradientViewHeight.constant + 8
        
        // Sets the gradients
        gradientView.setGradientBackground()
    }
}
