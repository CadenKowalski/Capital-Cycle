//
//  StorePage.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/7/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import StoreKit
import SafariServices

class StorePage: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: Global Variables
    
    // Storyboard outlets
    @IBOutlet weak var gradientView: CustomView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var storeLblYConstraint: NSLayoutConstraint!
    @IBOutlet weak var accountSettingsImgView: CustomImageView!
    @IBOutlet weak var productsCollection: UICollectionView!
    @IBOutlet weak var productsCollectionHeight: NSLayoutConstraint!
    // Code global vars
    let campProducts = [
        Product(Info: "Session 1 (4 days)\nfrom $375", ImgName: "CapitalCycleStoreLogo"),
        Product(Info: "Session 2 (5 days)\nfrom $430", ImgName: "CapitalCycleStoreLogo"),
        Product(Info: "Session 3 (4 days)\nfrom $375", ImgName: "CapitalCycleStoreLogo"),
        Product(Info: "Session 4 (5 days)\nfrom $430", ImgName: "CapitalCycleStoreLogo"),
        Product(Info: "Session 5 (5 days)\nfrom $430", ImgName: "CapitalCycleStoreLogo"),
        Product(Info: "Session 6 (5 days)\nfrom $430", ImgName: "CapitalCycleStoreLogo"),
        Product(Info: "Before care\n$10 per day", ImgName: "CapitalCycleStoreLogo"),
        Product(Info: "Camp T-shirt\n$20", ImgName: "ShirtImg")]
    let websiteURLs = ["https://capitalcyclecamp.org/pay-for-camp/5-day-session-1-6216",
        "https://capitalcyclecamp.org/pay-for-camp/1-5-day-session-of-cycle-camp-spring-break-and-summer-session-1245",
        "https://capitalcyclecamp.org/pay-for-camp/4-day-session-of-cycle-camp",
        "https://capitalcyclecamp.org/pay-for-camp/session-4-5-day-71116",
        "https://capitalcyclecamp.org/pay-for-camp/5-day-session-5-71816",
        "https://capitalcyclecamp.org/pay-for-camp/5-day-session-5-71816-7rnnm",
        "https://capitalcyclecamp.org",
        "https://capitalcyclecamp.org/pay-for-camp/bike-camp-t-shirt"]

    // MARK: View Instantiation
    
    // Runs when the view is loaded for the first time
    override func viewDidLoad() {
        super.viewDidLoad()
        storePage = self
        formatUI()
    }
    
    // MARK: View Formatting
    
    // Formats the UI
    func formatUI() {
        // Formats the gradient view
        if view.frame.height < 700 {
            gradientViewHeight.constant = 0.15 * view.frame.height
            gradientView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.15)
        } else if view.frame.height >= 812 {
            storeLblYConstraint.constant = 15
        }
        
        // Formats the products collection view
        productsCollection.delegate = self
        productsCollection.dataSource = self
        productsCollectionHeight.constant = view.frame.maxY - gradientView.frame.maxY

        // Formats the account settings button
        storePage?.accountSettingsImgView = accountSettingsImgView
        setProfileImg()
    }
    
    // Sets the profile image on the account settings button
    func setProfileImg() {
        accountSettingsImgView.image = user.profileImg
    }
    
    // MARK: Collection View Setup
    
    // Returns the number of products
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return campProducts.count
    }
    
    // Loads the product data into the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell {
            let Product = campProducts[indexPath.row]
            Cell.updateViews(Product: Product)
            Cell.layer.cornerRadius = 20
            Cell.layer.masksToBounds = true
            return Cell
        }
        
        return ProductCell()
    }
    
    // Takes the user to the products respective website URL
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewFunctions.giveHapticFeedback(error: false, prefers: user.prefersHapticFeedback!)
        let websiteURL = URL(string: "\(websiteURLs[indexPath.row])")!
        let sVC = SFSafariViewController(url: websiteURL)
        present(sVC, animated: true, completion: nil)
    }
}

//MARK: Extensions

// Dynamically adjusts the cell size based on the screen size
extension StorePage: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 9, height: (view.frame.width / 2 - 12) * 1.4)
    }
}
