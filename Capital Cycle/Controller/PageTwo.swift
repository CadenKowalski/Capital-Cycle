//
//  PageTwo.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/7/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST

class PageTwo: UIViewController {

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var scrollViewDisplay: UIView!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var dailyDateLbl: UILabel!
    @IBOutlet weak var overviewBtn: UIButton!
    @IBOutlet weak var eightActivityLbl: UILabel!
    @IBOutlet weak var nineActivityLbl: UILabel!
    @IBOutlet weak var tenActivityLbl: UILabel!
    @IBOutlet weak var elevenActivityLbl: UILabel!
    @IBOutlet weak var twelveActivityLbl: UILabel!
    @IBOutlet weak var oneActivityLbl: UILabel!
    @IBOutlet weak var twoActivityLbl: UILabel!
    @IBOutlet weak var threeActivityLbl: UILabel!
    @IBOutlet weak var fourActivityLbl: UILabel!
    @IBOutlet weak var fiveActivityLbl: UILabel!
    @IBOutlet weak var sixActivityLbl: UILabel!
    @IBOutlet weak var itemsLbl: UILabel!
    @IBOutlet weak var overviewScrollView: UIView!
    @IBOutlet weak var overviewView: UIView!
    @IBOutlet weak var overviewDateLbl: UILabel!
    @IBOutlet weak var dailyBtn: UIButton!
    @IBOutlet weak var mondayLbl: UILabel!
    @IBOutlet weak var tuesdayLbl: UILabel!
    @IBOutlet weak var wednesdayLbl: UILabel!
    @IBOutlet weak var thursdayLbl: UILabel!
    @IBOutlet weak var fridayLbl: UILabel!
    private let Service = GTLRSheetsService()
    let spreadsheetID = "1alCW-eSX-lC6CUi0lbmNK7hpfkUhpOqhrbWZCBJgXuk"
    let Day = Calendar.current.component(.weekday, from: Date())
    let Hour = Calendar.current.component(.hour, from: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Service.apiKey = "AIzaSyBIdPHR_nqgL9G6fScmlcPMReBM5PmtVD8"
        customizeLayout()
        fetchDailyData()
        fetchOverviewData()
    }
    
    // Formats the UI
    func customizeLayout() {
        // Sets gradients
        gradientView.setTwoGradientBackground(colorOne: Colors.Orange, colorTwo: Colors.Purple)
        dailyBtn.setTwoGradientButton(colorOne: Colors.Orange, colorTwo: Colors.Purple, cornerRadius: 10)
        overviewBtn.setTwoGradientButton(colorOne: Colors.Orange, colorTwo: Colors.Purple, cornerRadius: 11)
        
        // Formats the daily date label
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        dailyDateLbl.text = "\(formatter.string(from: Date()))"
        
        // Formats the start of week label
        overviewDateLbl.text = "\(formatter.string(from: Date().startOfWeek!))"
        
        // Formats the daily button
        let Days = ["M", "T", "W", "TH", "F"]
        dailyBtn.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 17.0)
        dailyBtn.titleLabel?.textAlignment = .center
        if Day == 7 || Day == 1 {
            dailyBtn.setTitle("Monday", for: .normal)
        } else {
            if Hour > 17 {
                dailyBtn.setTitle("\(Days[Day - 1])", for: .normal)
            } else {
                dailyBtn.setTitle("\(Days[Day - 2])", for: .normal)
            }
        }
    }
    
    // MARK: Daily spreadsheet data
    
    // Fetches daily spreadsheet data
    func fetchDailyData() {
        let Range = "Schedule Data!A2:M6"
        let Query = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: spreadsheetID, range: Range)
        Service.executeQuery(Query, delegate: self, didFinish: #selector(displayDailyData(Ticket:finishedWithObject:Error:)))
    }
    
    // Displays daily spreadhseet data
    @objc func displayDailyData(Ticket: GTLRServiceTicket, finishedWithObject Result: GTLRSheets_ValueRange, Error: NSError?) {
        let activityLblList = [eightActivityLbl, nineActivityLbl, tenActivityLbl, elevenActivityLbl, twelveActivityLbl, oneActivityLbl, twoActivityLbl, threeActivityLbl, fourActivityLbl, fiveActivityLbl, sixActivityLbl, itemsLbl]
        let weekActivitiesList = Result.values!
        let dayActivitiesList: Array<Any>
        
        // Decides which day to show
        if Day == 7 {
            dayActivitiesList = weekActivitiesList[0]
        } else {
            if Hour > 17 {
                dayActivitiesList = weekActivitiesList[Day - 1]
            } else {
                dayActivitiesList = weekActivitiesList[Day - 2]
            }
        }
        
        // Outputs data
        var Index = 0
        for Activity in dayActivitiesList[1..<13] {
            activityLblList[Index]?.text = "\(Activity)"
            Index += 1
        }
        
        dayLbl.text = "\(dayActivitiesList[0])"
    }
    
    // MARK: Overview spreadhseet data
    
    // Fetches overview spreadhseet data
    func fetchOverviewData() {
        let Range = "Schedule Data!A9:C13"
        let Query = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: spreadsheetID, range: Range)
        Service.executeQuery(Query, delegate: self, didFinish: #selector(displayOverviewData(Ticket:finishedWithObject:Error:)))
    }
    
    // Displays overview spreadsheet data
    @objc func displayOverviewData(Ticket: GTLRServiceTicket, finishedWithObject Result: GTLRSheets_ValueRange, Error: NSError?) {
        let overviewList = [mondayLbl, tuesdayLbl, wednesdayLbl, thursdayLbl, fridayLbl]
        let Week = Result.values! // 2D list of all the days
        var Index = 0
        for Day in Week {
            overviewList[Index]?.text = "\(Day[1])\n\(Day[2])"
            Index += 1
        }
    }
    
    // Switches between the overview and daily views
    @IBAction func switchViews(_ sender: UIButton) {
        if overviewScrollView.isHidden {
            overviewScrollView.isHidden = false
        } else {
            overviewScrollView.isHidden = true
        }
    }
}

// MARK: Extensions

extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
}

// Fetches the start date of a week
extension Date {
    var startOfWeek: Date? {
        return Calendar.gregorian.date(from: Calendar.gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
    }
}
