//
//  OverviewPage.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/7/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import MapKit

class OverviewPage: UIViewController {

    // MARK: Global Variables
    
    // Storyboard outlets
    @IBOutlet weak var gradientView: CustomView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var overviewLblYConstraint: NSLayoutConstraint!
    @IBOutlet weak var accountSettingsImgView: CustomImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    // Code global vars
    var contentHeight: CGFloat = 8
    let overviewCells = [OverviewCell(Header: "Camp Dates:", Body: "Session 1: Jun 23 - 26\nSession 2: Jun/Jul 30 - 3\nSession 3: Jul 6 - 10\nSession 4: Jul 13 - 17\nSession 5: Jul 20 - 24\nSession 6: Jul 27 - 31"), OverviewCell(Header: "Camp Hours:", Body: "9AM - 6PM\nOR\n8AM - 6PM with before care"), OverviewCell(Header: "Camp Location:", Body: "Miner Elemetary\n601 15th St NE Washington, DC 20002"), OverviewCell(Header: "Camp Price:", Body: "Sessions 1 & 2: $375\nSessions 3, 4, 5 & 6: $430\nBefore Care: $10 per day"), OverviewCell(Header: "Questions:", Body: "Camp Owner - Curtis Taylor\nPhone:\n(410) 428-0726\nEmail:\nCapitalCycleCamp@gmail.com"), OverviewCell(Header: "Typical Day:", Body: "Early drop off begins at 8AM and parents can drop off their campers any time after that. Camp begins at 9AM and campers will play a variety of games at the school for about an hour to allow time for eveyone to arrive. At around 10AM, we prepare to leave (aaply sunscreen, fill waterbottles, use the bathroom, pack backpacks, etc). We will usually bike all of the way to our destination and once we get there, we will eat lunch and do the activity that we have planned. At arround 3-4PM we will bike back to the school and play games until parents come to pick up their campers.")]
    
    // MARK: View Instantiation
    
    // Runs when the view is loaded for the first time
    override func viewDidLoad() {
        super.viewDidLoad()
        overviewPage = self
        formatUI()
    }
    
    // Adjusts the size of the scroll view
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: view.frame.width, height: contentHeight)
        contentView.frame.size = scrollView.contentSize
    }
    
    // MARK: View Formatting
    
    // Formats the UI
    func formatUI() {
        // Formats the gradient view
        if view.frame.height < 700 {
            gradientViewHeight.constant = 0.15 * view.frame.height
            gradientView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: gradientViewHeight.constant)
        } else if view.frame.height >= 812 {
           overviewLblYConstraint.constant = 15
        }
        
        // Formats the account settings button
        overviewPage?.accountSettingsImgView = accountSettingsImgView
        setProfileImg()
        
        // Creates the overview cells
        for cell in overviewCells {
            let headerLabel = UILabel(frame: CGRect(x: 8, y: 8, width: view.frame.width - 32, height: 28))
            headerLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
            headerLabel.textColor = UIColor(named: "CellTextColor")
            headerLabel.text = "\(cell.header)"
            let bodyLabel = UILabel(frame: CGRect(x: 32, y: 44, width: view.frame.width - 56, height: 100))
            if cell.header == "Camp Location:" {
                let attributedString = NSMutableAttributedString.init(string: "Miner Elemetary\n601 15th St NE Washington, DC 20002")
                attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange.init(location: 15, length: 36))
                bodyLabel.attributedText = attributedString
                bodyLabel.isUserInteractionEnabled = true
                let locationTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openMapsToLocation(_:)))
                bodyLabel.addGestureRecognizer(locationTapGestureRecognizer)
            } else {
                bodyLabel.text = "\(cell.body)"
            }
            
            bodyLabel.numberOfLines = 0
            bodyLabel.font = UIFont(name: "Avenir-Medium", size: 17)
            bodyLabel.textColor = UIColor(named: "CellTextColor")
            bodyLabel.sizeToFit()
            let overviewView = CustomView()
            overviewView.frame =  CGRect(x: 8, y: contentHeight, width: view.frame.width - 16, height: headerLabel.frame.height + bodyLabel.frame.height + 24)
            overviewView.cornerRadius = 20
            overviewView.cellGradient = true
            overviewView.addSubview(headerLabel)
            overviewView.addSubview(bodyLabel)
            contentView.addSubview(overviewView)
            contentHeight += (overviewView.frame.height + 8)
        }
        
        // Adds the social media links
        let instagramButton = UIButton(frame: CGRect(x: view.frame.maxX - 150, y: contentHeight, width: 50, height: 50))
        instagramButton.setImage(UIImage(named: "InstagramLogo"), for: .normal)
        instagramButton.addTarget(self, action: #selector(Instagram(_:)), for: .touchUpInside)
        let facebookButton = UIButton(frame: CGRect(x: view.frame.minX + 100, y: contentHeight, width: 50, height: 50))
        facebookButton.setImage(UIImage(named: "FacebookLogo"), for: .normal)
        facebookButton.addTarget(self, action: #selector(Facebook(_:)), for: .touchUpInside)
        contentView.addSubview(instagramButton)
        contentView.addSubview(facebookButton)
        contentHeight += 58
    }
    
    // Sets the profile image on the account settings button
    func setProfileImg() {
        accountSettingsImgView.image = user.profileImg!
    }
    
    // MARK: Actions
    
    // Opens the maps app to the camp location
    @objc func openMapsToLocation(_ sender: UITapGestureRecognizer) {
        viewFunctions.giveHapticFeedback(error: false, prefers: user.prefersHapticFeedback!)
        let latitude: CLLocationDegrees = 38.8975
        let longitude: CLLocationDegrees = -76.9829
        let regionDistance: CLLocationDistance = 500
        let Coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: Coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let Options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        let Placemark = MKPlacemark(coordinate: Coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: Placemark)
        mapItem.name = "Miner Elementary"
        mapItem.openInMaps(launchOptions: Options)
    }
    
    // Takes the user to the CapitalCycleCamp Facebook page
    @objc func Facebook(_ sender: UIButton) {
        viewFunctions.giveHapticFeedback(error: false, prefers: user.prefersHapticFeedback!)
        let facebookAppURL = URL(string: "fb://profile/839679162770435")!
        if UIApplication.shared.canOpenURL(facebookAppURL) {
            UIApplication.shared.open(facebookAppURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string: "https://www.facebook.com/CapitalCycleCamp/")!, options: [:], completionHandler: nil)
        }
    }
    
    // Takes the user to the CapitalCycleCamp Instagram page
    @objc func Instagram(_ sender: UIButton) {
        viewFunctions.giveHapticFeedback(error: false, prefers: user.prefersHapticFeedback!)
        let instagramURL = NSURL(string: "instagram://capitalcyclecamp/")! as URL
        if UIApplication.shared.canOpenURL(instagramURL as URL) {
            UIApplication.shared.open(instagramURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(NSURL(string: "https://instagram.com/capitalcyclecamp/")! as URL)
        }
    }
}
