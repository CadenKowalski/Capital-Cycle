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
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var overviewLblYConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewYConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewDisplay: UIView!
    @IBOutlet weak var locationLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeLayout()
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
        
        // Sets the gradients
        gradientView.setGradientBackground()
        
        // Readjusts the Y constraints
        scrollViewYConstraint.constant = gradientViewHeight.constant + 8
        
        // Sets up the location lbl
        locationLbl.isUserInteractionEnabled = true
    }
    
    // MARK: Actions
    
    // Opens the maps app to the camp location
    @IBAction func openMapsToLocation(_ sender: UITapGestureRecognizer) {
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
}
