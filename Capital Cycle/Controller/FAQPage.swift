//
//  FAQPage.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/9/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit

class FAQPage: UIViewController {
    
    // MARK: Global Variables
    
    // Storyboard outlets
    @IBOutlet weak var gradientView: CustomView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var FAQLblYConstraint: NSLayoutConstraint!
    @IBOutlet weak var accountSettingsImgView: CustomImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    // Code global vars
    let questionCategories = ["Schedule", "Payment", "Drop-off/Pickup", "Preparation"]
    let questionWidths = [88, 84, 138, 108]
    var currentCategory: CustomButton!
    
    // MARK: View Instantiation
    
    // Runs when the view is loaded for the first time
    override func viewDidLoad() {
        super.viewDidLoad()
        faqPage = self
        formatUI()
    }
    
    // Adjusts the size of the scroll view
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: 458, height: 37)
        contentView.frame.size = scrollView.contentSize
    }
    
    // MARK: View Formatting
    
    // Formats the UI
    func formatUI() {
        // Formats the gradient view
        if view.frame.height < 700 {
            gradientViewHeight.constant = 0.15 * view.frame.height
            gradientView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.15)
        } else if view.frame.height >= 812 {
            FAQLblYConstraint.constant = 15
        }
        
        // Formats the account settings button
        faqPage?.accountSettingsImgView = accountSettingsImgView
        setProfileImg()
        
        // Creates the scroll view
        scrollView.showsHorizontalScrollIndicator = false
        var x = 0
        for i in 0 ..< questionCategories.count {
            let padding = 8 * (i + 1)
            let button = CustomButton(frame: CGRect(x: x + padding, y: 2, width: questionWidths[i], height: 33))
            x += questionWidths[i]
            button.setTitle(questionCategories[i], for: .normal)
            button.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 16)
            button.addTarget(self, action: #selector(switchCategory(_:)), for: .touchUpInside)
            button.cornerRadius = 16
            if i == 0 {
                button.gradient = true
                currentCategory = button
            } else {
                button.borderRadius = 0.5
                button.borderColor = UIColor(named: "LabelColor")!
            }
            
            contentView.addSubview(button)
        }
    }
    
    // Sets the profile image on the account settings button
    func setProfileImg() {
        accountSettingsImgView.image = user.profileImg
    }
    
    // Switches between question categories
    @objc func switchCategory(_ sender: CustomButton) {
        currentCategory.gradient = false
        currentCategory.borderRadius = 0.5
        currentCategory.borderColor = UIColor(named: "LabelColor")!
        sender.gradient = true
        sender.borderRadius = 0
        sender.borderColor = .clear
        currentCategory = sender
    }
}
