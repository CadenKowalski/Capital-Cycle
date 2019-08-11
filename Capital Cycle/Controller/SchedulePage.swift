//
//  SchedulePage.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/7/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import CoreData

class SchedulePage: UIViewController {
    // Storyboard outlets
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    // Daily scroll view
    @IBOutlet weak var dailyScrollView: UIScrollView!
    @IBOutlet weak var dailyScrollViewYConstraint: NSLayoutConstraint!
    @IBOutlet weak var dailyScrollViewDisplay: UIView!
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
    // Overview scroll view
    @IBOutlet weak var overviewScrollView: UIView!
    @IBOutlet weak var overviewScrollViewYConstraint: NSLayoutConstraint!
    @IBOutlet weak var overviewScroll: UIScrollView!
    @IBOutlet weak var overviewScrollViewDisplay: UIView!
    @IBOutlet weak var overviewDateLbl: UILabel!
    @IBOutlet weak var dailyBtn: UIButton!
    @IBOutlet weak var mondayLbl: UILabel!
    @IBOutlet weak var tuesdayLbl: UILabel!
    @IBOutlet weak var wednesdayLbl: UILabel!
    @IBOutlet weak var thursdayLbl: UILabel!
    @IBOutlet weak var fridayLbl: UILabel!
    @IBOutlet weak var noConnectionView: UIView!
    // Code global vars
    let Day = Calendar.current.component(.weekday, from: Date())
    let Hour = Calendar.current.component(.hour, from: Date())
    let spreadsheetID = "1alCW-eSX-lC6CUi0lbmNK7hpfkUhpOqhrbWZCBJgXuk"
    var dailyRefreshControl = UIRefreshControl()
    var overviewRefreshControl = UIRefreshControl()
    let Service = GTLRSheetsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeLayout()
        fetchDailyData()
        fetchOverviewData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if !Reachability.isConnectedToNetwork() {
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.noConnectionView.alpha = 1})
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.noConnectionView.alpha = 0})
            })
        }
    }
    
    // MARK: View Setup
    
    // Formats the UI
    func customizeLayout() {
        // Formats the gradient view
        gradientViewHeight.constant = 0.15 * view.frame.height
        gradientView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.15)
        
        // Readjusts the Y constraints relative to the gradient view height
        dailyScrollViewYConstraint.constant = gradientView.frame.height + 8
        overviewScrollViewYConstraint.constant = gradientView.frame.height + 8
        
        // Sets gradients
        gradientView.setTwoGradientBackground()
        dailyBtn.setTwoGradientButton(cornerRadius: 10)
        overviewBtn.setTwoGradientButton(cornerRadius: 11)
        
        // Sets the API key for the GTLR Service so that the app can access the spreadhseet without credentials
        Service.apiKey = "AIzaSyBIdPHR_nqgL9G6fScmlcPMReBM5PmtVD8"
        
        // Formats the daily date label
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        dailyDateLbl.text = "\(formatter.string(from: Date()))"
        
        // Formats the start of week label
        overviewDateLbl.text = "\(formatter.string(from: Date().startOfWeek!))"
        
        // Formats the daily button
        let Days = ["Mon", "Tues", "Wed", "Thurs", "Fri"]
        if Day == 7 || Day == 1 {
            dailyBtn.setTitle("Mon", for: .normal)
        } else {
            if Hour > 17 {
                if Day == 6 {
                    dailyBtn.setTitle("Mon", for: .normal)                }
                else {
                    dailyBtn.setTitle("\(Days[Day - 1])", for: .normal)
                }
            } else {
                dailyBtn.setTitle("\(Days[Day - 2])", for: .normal)
            }
        }
        
        // Formats the no connection view
        noConnectionView.layer.cornerRadius = 20
        noConnectionView.alpha = 0
        
        // Formats the refresh view
        dailyRefreshControl.backgroundColor = UIColor(named: "ViewColor")
        dailyRefreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        dailyScrollView.refreshControl = dailyRefreshControl
        overviewRefreshControl.backgroundColor = UIColor(named: "ViewColor")
        overviewRefreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        overviewScroll.refreshControl = overviewRefreshControl
    }
    
    // MARK: Daily Spreadsheet Data

    // Fetches the daily spreadsheet data
    func fetchDailyData() {
        let Range = "Schedule Data!A2:M6"
        let Query = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: spreadsheetID, range: Range)
        Service.executeQuery(Query, delegate: self, didFinish: #selector(displayDailyData(Ticket:finishedWithObject:Error:)))
    }
    
    // Displays the daily spreadsheet data
    @objc func displayDailyData(Ticket: GTLRServiceTicket, finishedWithObject Result: GTLRSheets_ValueRange, Error: NSError?) {
        let activityLblList = [eightActivityLbl, nineActivityLbl, tenActivityLbl, elevenActivityLbl, twelveActivityLbl, oneActivityLbl, twoActivityLbl, threeActivityLbl, fourActivityLbl,fiveActivityLbl, sixActivityLbl, itemsLbl]
        if Reachability.isConnectedToNetwork() {
            weekActivitiesList = Result.values! as? [[String]]
            updateContext()
        }
        
        let dayActivitiesList: Array<Any>
        
        // Decides which days data to show
        if Day == 7 || Day == 1 {
            dayActivitiesList = weekActivitiesList[0]
        } else {
            if Hour > 17 {
                if Day == 6 {
                    dayActivitiesList = weekActivitiesList[0]
            } else {
                    dayActivitiesList = weekActivitiesList[Day - 1]
                }
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
    
    // MARK: Overview Spreadhseet Data
    
    // Fetches overview spreadhseet data
    func fetchOverviewData() {
        let Range = "Schedule Data!A9:C13"
        let Query = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: spreadsheetID, range: Range)
        Service.executeQuery(Query, delegate: self, didFinish: #selector(setOverviewData(Ticket:finishedWithObject:Error:)))
    }
    
    // Displays the overview spreadsheet data
    @objc func setOverviewData(Ticket: GTLRServiceTicket, finishedWithObject Result: GTLRSheets_ValueRange, Error: NSError?) {
        let overviewList = [mondayLbl, tuesdayLbl, wednesdayLbl, thursdayLbl, fridayLbl]
        if Reachability.isConnectedToNetwork() {
            Week = Result.values! as? [[String]]
            updateContext()
        }
        var Index = 0
        for Day in Week {
            overviewList[Index]?.text = "\(Day[1])\n\(Day[2])"
            Index += 1
        }
    }
    
    // Refreshes the schedule labels if there is an internet connection
    @objc func updateData(_ sender: UIRefreshControl) {
        if Reachability.isConnectedToNetwork() {
            fetchDailyData()
            fetchOverviewData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                sender.endRefreshing()
            })
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                sender.endRefreshing()
            })
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

// MARK: Core Data
    
// Updates the context with new values
    func updateContext() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let Context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Spreadsheet")
        do {
            let fetchResults = try Context.fetch(fetchRequest)
            let Spreadsheet = fetchResults.first as! NSManagedObject
            Spreadsheet.setValue(weekActivitiesList, forKey: "dailyData")
            Spreadsheet.setValue(Week, forKey: "overviewData")
            try Context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

// MARK: Extensions

// Sets the type of calendar
extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
}

// Fetches the start date of a week
extension Date {
    var startOfWeek: Date? {
        return Calendar.gregorian.date(from: Calendar.gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
    }
}
