//
//  SchedulePage.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/7/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit

class SchedulePage: UIViewController {
    
    // MARK: Global Variables
    
    // Storyboard outlets
    @IBOutlet weak var gradientView: CustomView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scheduleLblYConstraint: NSLayoutConstraint!
    @IBOutlet weak var accountSettingsImgView: CustomImageView!
    // Daily scroll view
    @IBOutlet weak var dailyScrollView: UIScrollView!
    @IBOutlet weak var dailyScrollViewYConstraint: NSLayoutConstraint!
    @IBOutlet weak var dailyScrollViewDisplay: UIView!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var dailyDateLbl: UILabel!
    @IBOutlet weak var overviewBtn: CustomButton!
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
    @IBOutlet weak var dailyBtn: CustomButton!
    @IBOutlet weak var mondayLbl: UILabel!
    @IBOutlet weak var tuesdayLbl: UILabel!
    @IBOutlet weak var wednesdayLbl: UILabel!
    @IBOutlet weak var thursdayLbl: UILabel!
    @IBOutlet weak var fridayLbl: UILabel!
    @IBOutlet weak var noConnectionView: UIView!
    // Code global vars
    static let Instance = SchedulePage()
    let Day = Calendar.current.component(.weekday, from: Date())
    let Hour = Calendar.current.component(.hour, from: Date())
    var dailyRefreshControl = UIRefreshControl()
    var overviewRefreshControl = UIRefreshControl()
    
    // MARK: View Instantiation
    
    // Runs when the view is loaded for the first time
    override func viewDidLoad() {
        super.viewDidLoad()
        formatUI()
        formatDailyData()
        formatOverviewData()
    }
    
    // Runs when the view is reloaded
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setProfileImg()
        if !Reachability.isConnectedToNetwork() {
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.noConnectionView.alpha = 1})
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.noConnectionView.alpha = 0})
            })
        }
    }
    
    // MARK: View Formatting
    
    // Formats the UI
    func formatUI() {
        // Formats the gradient view
        if view.frame.height < 700 {
            gradientViewHeight.constant = 0.15 * view.frame.height
            gradientView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.15)
        } else if view.frame.height >= 812 {
           scheduleLblYConstraint.constant = 15
        }
        
        // Formats the refresh view
        dailyRefreshControl.backgroundColor = UIColor(named: "ViewColor")
        dailyRefreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        dailyScrollView.refreshControl = dailyRefreshControl
        overviewRefreshControl.backgroundColor = UIColor(named: "ViewColor")
        overviewRefreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        overviewScroll.refreshControl = overviewRefreshControl
        
        // Formats the start of week label
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        overviewDateLbl.text = "\(formatter.string(from: Date().startOfWeek!))"
        
        // Formats the daily date label
        dailyDateLbl.text = "\(formatter.string(from: Date()))"
        
        // Formats the daily button
        let Days = ["Mon", "Tues", "Wed", "Thurs", "Fri"]
        if Day == 7 || Day == 1 {
            dailyBtn.setTitle("Mon", for: .normal)
        } else {
            if Hour > 17 {
                if Day == 6 {
                    dailyBtn.setTitle("Mon", for: .normal)
                } else {
                    dailyBtn.setTitle("\(Days[Day - 1])", for: .normal)
                }
            } else {
                dailyBtn.setTitle("\(Days[Day - 2])", for: .normal)
            }
        }
        
        // Formats the account settings button
        SchedulePage.Instance.accountSettingsImgView = accountSettingsImgView
        setProfileImg()
        
        // Formats the Y constraints relative to the gradient view height
        dailyScrollViewYConstraint.constant = gradientView.frame.height + 8
        overviewScrollViewYConstraint.constant = gradientView.frame.height + 8
    }
    
    // Sets the profile image on the account settings button
    func setProfileImg() {
        accountSettingsImgView.image = user.profileImg
    }
    
    // MARK: Spreadsheet Data

    // Formats the daily spreadsheet data
    func formatDailyData() {
        let activityLblList = [eightActivityLbl, nineActivityLbl, tenActivityLbl, elevenActivityLbl, twelveActivityLbl, oneActivityLbl, twoActivityLbl, threeActivityLbl, fourActivityLbl,fiveActivityLbl, sixActivityLbl, itemsLbl]
        let dayActivitiesList: Array<Any>
        
        // Decides which days data to show
        if Day == 7 || Day == 1 {
            dayActivitiesList = dailyData[0]
        } else {
            if Hour > 17 {
                if Day == 6 {
                    dayActivitiesList = dailyData[0]
                } else {
                    dayActivitiesList = dailyData[Day - 1]
                }
            } else {
                dayActivitiesList = dailyData[Day - 2]
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
    
    // Formats the overview spreadhseet data
    func formatOverviewData() {
        let overviewList = [mondayLbl, tuesdayLbl, wednesdayLbl, thursdayLbl, fridayLbl]
        var Index = 0
        for Day in overviewData {
            overviewList[Index]?.text = "\(Day[1])\n\(Day[2])"
            Index += 1
        }
    }
    
    // Refreshes the schedule labels if there is an internet connection
    @objc func updateData(_ sender: UIRefreshControl) {
        if Reachability.isConnectedToNetwork() {
            googleFunctions.fetchData(secure: false, accessToken: nil) { error in
                DispatchQueue.main.async {
                    if error == nil {
                        self.formatDailyData()
                        self.formatOverviewData()
                    } else {
                        print(error!)
                    }
                    
                    sender.endRefreshing()
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                sender.endRefreshing()
            })
        }
    }
    
    // Switches between the overview and daily views
    @IBAction func switchViews(_ sender: CustomButton) {
        viewFunctions.giveHapticFeedback(error: false, prefers: user.prefersHapticFeedback!)
        if overviewScrollView.isHidden {
            overviewScrollView.isHidden = false
        } else {
            overviewScrollView.isHidden = true
        }
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
