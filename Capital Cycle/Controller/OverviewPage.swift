//
//  OverviewPage.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/7/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class OverviewPage: UIViewController {

    // Storyboard outlets
    @IBOutlet weak var gradientView: CustomView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var overviewLblYConstraint: NSLayoutConstraint!
    @IBOutlet weak var accountSettingsImgView: CustomImageView!
    @IBOutlet weak var scrollViewYConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewDisplay: UIView!
    @IBOutlet weak var locationLbl: UILabel!
    // Global code vars
    static let Instance = OverviewPage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setProfileImg()
    }
    
    // MARK: View Setup
    
    // Formats the UI
    func customizeLayout() {
        // Formats the gradient view
        if view.frame.height < 700 {
            gradientViewHeight.constant = 0.15 * view.frame.height
            gradientView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.15)
        } else if view.frame.height >= 812 {
           overviewLblYConstraint.constant = 15
        }

        // Readjusts the Y constraints
        scrollViewYConstraint.constant = gradientViewHeight.constant + 8
        
        // Sets the profile image on the account settings button
        OverviewPage.Instance.accountSettingsImgView = accountSettingsImgView
        setProfileImg()
    }
    
    // Sets the profile image on the account settings button
    func setProfileImg() {
        accountSettingsImgView.image = profileImg
    }
    
    // Initiates haptic feedback
    func giveHapticFeedback() {
        if hapticFeedback {
            let feedbackGenerator = UISelectionFeedbackGenerator()
            feedbackGenerator.selectionChanged()
        }
    }
    
    // MARK: Actions
    
    // Opens the maps app to the camp location
    @IBAction func openMapsToLocation(_ sender: UITapGestureRecognizer) {
        giveHapticFeedback()
        let latitude: CLLocationDegrees = 38.8975
        let longitude: CLLocationDegrees = -76.9829
        let regionDistance: CLLocationDistance = 500
        let Coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: Coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let Options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        let Placemark = MKPlacemark(coordinate: Coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: Placemark)
        mapItem.name = "Minor Elementary"
        mapItem.openInMaps(launchOptions: Options)
    }
    
    // Takes the user to the CapitalCycleCamp Facebook page
    @IBAction func Facebook(_ sender: UIButton) {
        giveHapticFeedback()
        let facebookAppURL = URL(string: "fb://profile/839679162770435")!
        if UIApplication.shared.canOpenURL(facebookAppURL) {
            UIApplication.shared.open(facebookAppURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string: "https://www.facebook.com/CapitalCycleCamp/")!, options: [:], completionHandler: nil)
        }
    }
    
    // Takes the user to the CapitalCycleCamp Instagram page
    @IBAction func Instagram(_ sender: UIButton) {
        giveHapticFeedback()
        let instagramURL = NSURL(string: "instagram://capitalcyclecamp/")! as URL
        if UIApplication.shared.canOpenURL(instagramURL as URL) {
            UIApplication.shared.open(instagramURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(NSURL(string: "https://instagram.com/capitalcyclecamp/")! as URL)
        }
    }
}
