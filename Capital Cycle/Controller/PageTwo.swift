//
//  PageTwo.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/7/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit

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
    let Day = Calendar.current.component(.weekday, from: Date())
    let Hour = Calendar.current.component(.hour, from: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeLayout()
        displayDailyData()
        displayOverviewData()
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
        dailyBtn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 17.0)
        dailyBtn.titleLabel?.textAlignment = .center
        if Day == 7 || Day == 1 {
            dailyBtn.setTitle("M", for: .normal)
        } else {
            if Hour > 17 {
                dailyBtn.setTitle("\(Days[Day - 1])", for: .normal)
            } else {
                dailyBtn.setTitle("\(Days[Day - 2])", for: .normal)
            }
        }
    }
    
    // MARK: Daily spreadsheet data
    
    // Displays daily spreadhseet data
    func displayDailyData() {
        let activityLblList = [eightActivityLbl, nineActivityLbl, tenActivityLbl, elevenActivityLbl, twelveActivityLbl, oneActivityLbl, twoActivityLbl, threeActivityLbl, fourActivityLbl, fiveActivityLbl, sixActivityLbl, itemsLbl]
        let weekActivitiesList = dailyData.values! as! [[String]]
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
    
    // Displays overview spreadsheet data
    func displayOverviewData() {
        let overviewList = [mondayLbl, tuesdayLbl, wednesdayLbl, thursdayLbl, fridayLbl]
        let Week = overviewData.values! // 2D list of all the days
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
