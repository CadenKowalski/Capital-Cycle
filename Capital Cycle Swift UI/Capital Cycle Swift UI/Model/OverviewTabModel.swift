//
//  OverviewTabModel.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/10/20.
//

import Foundation
import MapKit

// MARK: OverviewCell Struct

struct OverviewCell: Identifiable {
    
    var title: String
    var text: String
    var id: Int
}

// MARK: OverviewTabModel

struct OverviewTabModel {
    
    let overviewCells = [
        OverviewCell(title: "Camp Dates:", text: "Session 1: Jun 23 - 26\nSession 2: Jun/Jul 30 - 3\nSession 3: Jul 6 - 10\nSession 4: Jul 13 - 17\nSession 5: Jul 20 - 24\nSession 6: Jul 27 - 31", id: 0),
        OverviewCell(title: "Camp Hours:", text: "9AM - 6PM\nOR\n8AM - 6PM with before care", id: 1),
        OverviewCell(title: "Camp Location:", text:  "St. Mark's Episcopal Church\n301 A St SE Washington, DC 20003", id: 2),
        OverviewCell(title: "Camp Price:", text: "Sessions 1 & 2: $375\nSessions 3, 4, 5 & 6: $430\nBefore Care: $10 per day", id: 3),
        OverviewCell(title: "Questions?", text: "Camp Owner - Curtis Taylor\nPhone:\n(410) 428-0726\nEmail:\nCapitalCycleCamp@gmail.com", id: 4),
        OverviewCell(title: "Typical Day:", text: "Early drop off begins at 8AM and parents can drop off their campers any time after that. Camp begins at 9AM and campers will play a variety of games at the school for about an hour to allow time for eveyone to arrive. At around 10AM, we prepare to leave (aaply sunscreen, fill waterbottles, use the bathroom, pack backpacks, etc). We will usually bike all of the way to our destination and once we get there, we will eat lunch and do the activity that we have planned. At arround 3-4PM we will bike back to the school and play games until parents come to pick up their campers.", id: 5),
    ]
    
    // MARK: Functions
    
    // Opens maps to the camp location
    static func redirectToCampLocation() {
        let latitude: CLLocationDegrees = 38.8885086
        let longitude: CLLocationDegrees = -77.0017451
        let regionDistance: CLLocationDistance = 10
        let Coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: Coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let Options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        let Placemark = MKPlacemark(coordinate: Coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: Placemark)
        mapItem.name = "St. Mark's Episcopal Church"
        mapItem.openInMaps(launchOptions: Options)
    }
    
    // Takes the user to Capital Cycle Camp's Facebook page
    func redirectToFacebook() {
        let facebookAppURL = URL(string: "fb://profile/839679162770435")!
        if UIApplication.shared.canOpenURL(facebookAppURL) {
            UIApplication.shared.open(facebookAppURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string: "https://www.facebook.com/CapitalCycleCamp/")!, options: [:], completionHandler: nil)
        }
    }
    
    // Takes the user to Capital Cycle Camp's Instagram page
    func redirectToInstagram() {
        let instagramURL = NSURL(string: "instagram://capitalcyclecamp/")! as URL
        if UIApplication.shared.canOpenURL(instagramURL as URL) {
            UIApplication.shared.open(instagramURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(NSURL(string: "https://instagram.com/capitalcyclecamp/")! as URL)
        }
    }
}
