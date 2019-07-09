//
//  PageThree.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/7/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import SafariServices

class PageThree: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var productsCollection: UICollectionView!
    @IBOutlet weak var productsCollectionHeight: NSLayoutConstraint!
    private(set) public var Products = [Product]()
    let websiteURLs = ["https://capitalcyclecamp.org/pay-for-camp/5-day-session-1-6216",
                       "https://capitalcyclecamp.org/pay-for-camp/1-5-day-session-of-cycle-camp-spring-break-and-summer-session-1245",
                       "https://capitalcyclecamp.org/pay-for-camp/4-day-session-of-cycle-camp",
                       "https://capitalcyclecamp.org/pay-for-camp/session-4-5-day-71116",
                       "https://capitalcyclecamp.org/pay-for-camp/5-day-session-5-71816",
                       "https://capitalcyclecamp.org/pay-for-camp/5-day-session-5-71816-7rnnm",
                       "https://capitalcyclecamp.org/pay-for-camp/bike-camp-t-shirt"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeLayout()
        loadProducts()
        productsCollection.delegate = self
        productsCollection.dataSource = self
    }
    
    // Formats the UI
    func customizeLayout() {
        // Formats the gradient view
        gradientView.setTwoGradientBackground(colorOne: Colors.Orange, colorTwo: Colors.Purple)
        
        // Sets UI constraints
        productsCollectionHeight.constant = view.frame.maxY - gradientView.frame.maxY
    }
    
    // MARK: Collection View
    
    // Loads the product in formation
    func loadProducts() {
        Products = ProductData.Instance.getProducts()
    }
    
    // Returns the number of products
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Products.count
    }
    
    // Loads the product data into the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell {
            let Product = Products[indexPath.row]
            Cell.updateViews(Product: Product)
            Cell.layer.cornerRadius = 20
            Cell.layer.masksToBounds = true
            return Cell
        }
        
        return ProductCell()
    }
    
    // Takes the user to the products respective website URL
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let websiteURL = URL(string: "\(websiteURLs[indexPath.row])")!
        let sVC = SFSafariViewController(url: websiteURL)
        present(sVC, animated: true, completion: nil)
    }
}

extension PageThree: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 9, height: (view.frame.width / 2 - 12) * 1.4)
    }
}
