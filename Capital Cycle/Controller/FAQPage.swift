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
    @IBOutlet weak var horizontalScrollView: UIScrollView!
    @IBOutlet weak var horizontalContentView: UIView!
    @IBOutlet weak var verticalScrollView: UIScrollView!
    @IBOutlet weak var verticalContentView: UIView!
    // Code global vars
    let questionCategories = ["All", "Schedule", "Payment", "Drop-off/Pickup", "Biking"]
    let categoryWidths = [60, 88, 84, 138, 67]
    var contentHeight: CGFloat!
    var currentCategory: CustomButton!
    let categories: [FAQCell.Category] = [.all, .schedule, .payment, .dropOffPickup, .biking]
    var faqViews = [CustomView]()
    let faqs: [FAQCell] = [FAQCell(Question: "When do you usually head out in the morning?", Answer: "Around 10:00 - 10:30.", Category: .schedule), FAQCell(Question: "When do you usually arrive back at camp?", Answer: "Around 3:00 - 4:00.", Category: .schedule), FAQCell(Question: "What if it rains?", Answer: "We will play it by ear but will err on the side of caution to ensure that campers remain safe.", Category: .schedule), FAQCell(Question: "Do you group kids by age or ability?", Answer: "Both, it typically depends on the length of the ride. However, the primary determining factor is whether or not the counselors believe that yout camper is ready for a given ride.", Category: .biking), FAQCell(Question: "What if my kid is unable to bike back from the destination?", Answer: "We generally push campers to make it back on their own but are prepared to call an Uber or Lyft if we beleive that your camper will not be able to make it back themselves.", Category: .biking), FAQCell(Question: "Can I get a sibling discout?", Answer: "TBD", Category: .payment), FAQCell(Question: "What if my child is not a cinfident rider", Answer: "We will work with them throughout the week pushing them outside their comfort zone but we can always put them in a less advanced group that will go a shorter distance", Category: .biking), FAQCell(Question: "What if I need to pick up my child early one day?", Answer: "Contact Curtis at (410) 428-0726 and we will make sure to have your camper back in time.", Category: .dropOffPickup), FAQCell(Question: "What if my child doesn't have a bike?", Answer: "We ask that all campers who attend bike camp, have a bike.", Category: .biking), FAQCell(Question: "Can my child arrive and/ or leave camp by themselves or di I need to be present?", Answer: "If you give the counselors explicit permission for your camper to arrive and/ or leave camp by themselves, they can do so.", Category: .dropOffPickup), FAQCell(Question: "What do you do when not biking?", Answer: "We have a variety of games and books as well as a gym and playground to occupy down time", Category: .schedule)]
    
    // MARK: View Instantiation
    
    // Runs when the view is loaded for the first time
    override func viewDidLoad() {
        super.viewDidLoad()
        faqPage = self
        formatUI()
        displayFaqs(category: .all)
    }
    
    // Adjusts the size of the scroll view
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontalScrollView.contentSize = CGSize(width: 504, height: 37)
        horizontalContentView.frame.size = horizontalScrollView.contentSize
        verticalScrollView.contentSize = CGSize(width: view.frame.width, height: contentHeight)
        verticalContentView.frame.size = verticalScrollView.contentSize
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
        
        // Creates the horizontal scroll view
        horizontalScrollView.showsHorizontalScrollIndicator = false
        var x = 8
        for i in 0 ..< questionCategories.count {
            let padding = 8 * (i + 1)
            let button = CustomButton(frame: CGRect(x: x + padding, y: 2, width: categoryWidths[i], height: 33))
            x += categoryWidths[i]
            button.setTitle(questionCategories[i], for: .normal)
            button.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 16)
            button.addTarget(self, action: #selector(switchCategory(_:)), for: .touchUpInside)
            button.cornerRadius = 16
            button.tag = i
            if i == 0 {
                button.gradient = true
                currentCategory = button
            } else {
                button.borderRadius = 0.5
                button.borderColor = UIColor(named: "LabelColor")!
                button.setTitleColor(UIColor(named: "LabelColor"), for: .normal)
            }
            
            horizontalContentView.addSubview(button)
        }
    }
    
    // Manages the FAQs
    func displayFaqs(category: FAQCell.Category) {
        for view in faqViews {
            view.removeFromSuperview()
        }
        
        faqViews = []
        contentHeight = 8
        for faq in faqs {
            if faq.category == category || category == .all {
                let faqLabel = UILabel(frame: CGRect(x: 8, y: 8, width: view.frame.width - 32, height: 100))
                faqLabel.numberOfLines = 0
                faqLabel.font = UIFont(name: "Avenir-Medium", size: 20)
                faqLabel.textColor = UIColor(named: "CellTextColor")
                faqLabel.text = "Q: " + "\(faq.question)" + "\n" + "A: " +  "\(faq.answer)"
                faqLabel.sizeToFit()
                let faqView = CustomView()
                faqView.frame =  CGRect(x: 8, y: contentHeight, width: view.frame.width - 16, height: faqLabel.frame.height + 16)
                contentHeight += (faqView.frame.height + 8)
                faqView.cornerRadius = 20
                faqView.cellGradient = true
                faqView.addSubview(faqLabel)
                verticalContentView.addSubview(faqView)
                faqViews.append(faqView)
            }
        }
        
        let contentViewHeight = view.frame.height - (87 + gradientViewHeight.constant)
        if contentViewHeight - contentHeight > 0 {
            contentHeight += (contentViewHeight - contentHeight) + 1
        }

        verticalScrollView.contentSize = CGSize(width: view.frame.width, height: contentHeight)
        verticalContentView.frame.size = verticalScrollView.contentSize
    }
    
    // Sets the profile image on the account settings button
    func setProfileImg() {
        accountSettingsImgView.image = user.profileImg
    }
    
    // Switches between question categories
    @objc func switchCategory(_ sender: CustomButton) {
        viewFunctions.giveHapticFeedback(error: false, prefers: user.prefersHapticFeedback)
        currentCategory.gradient = false
        currentCategory.borderRadius = 0.5
        currentCategory.borderColor = UIColor(named: "LabelColor")!
        currentCategory.setTitleColor(UIColor(named: "LabelColor"), for: .normal)
        sender.gradient = true
        sender.borderRadius = 0
        sender.borderColor = .clear
        sender.setTitleColor(UIColor(named: "CellTextColor"), for: .normal)
        currentCategory = sender
        displayFaqs(category: categories[sender.tag])
    }
}
