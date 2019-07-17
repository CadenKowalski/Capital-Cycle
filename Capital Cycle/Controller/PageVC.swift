//
//  PageVC.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 6/17/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST

var dailyData = GTLRSheets_ValueRange()
var overviewData = GTLRSheets_ValueRange()

class PageVC: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var pageControl = UIPageControl()
    private let Service = GTLRSheetsService()
    let spreadsheetID = "1alCW-eSX-lC6CUi0lbmNK7hpfkUhpOqhrbWZCBJgXuk"
    lazy var orderedVCs: [UIViewController] = {
        return [self.newVC(VC: "PageOne"), self.newVC(VC: "PageTwo"), self.newVC(VC: "PageThree"), self.newVC(VC: "PageFour")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let firstVC = orderedVCs.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        self.delegate = self
        configurePageControl()
        Service.apiKey = "AIzaSyBIdPHR_nqgL9G6fScmlcPMReBM5PmtVD8"
        fetchDailyData()
        fetchOverviewData()
    }
    
    // MARK: Fetch Spreadhseet Data
    
    // Fetches daily spreadsheet data
    func fetchDailyData() {
        let Range = "Schedule Data!A2:M6"
        let Query = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: spreadsheetID, range: Range)
        Service.executeQuery(Query, delegate: self, didFinish: #selector(setDailyData(Ticket:didFinishSelector:Error:)))
    }
    
    // Sets the spreadsheet data to a global variable
    @objc func setDailyData(Ticket: GTLRServiceTicket, didFinishSelector Result: GTLRSheets_ValueRange, Error: NSError?) {
        dailyData = Result
    }
    
    // Fetches overview spreadhseet data
    func fetchOverviewData() {
        let Range = "Schedule Data!A9:C13"
        let Query = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: spreadsheetID, range: Range)
        Service.executeQuery(Query, delegate: self, didFinish: #selector(setOverviewData(Ticket:didFinishSelector:Error:)))
    }
    
    // Sets the spreadsheet data to a global variable
    @objc func setOverviewData(Ticket: GTLRServiceTicket, didFinishSelector Result: GTLRSheets_ValueRange, Error: NSError?) {
        overviewData = Result
    }
    
    // MARK: Set Up Page View Controller
    
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
        pageControl.numberOfPages = orderedVCs.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.view.addSubview(pageControl)
    }
    
    func newVC(VC: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: VC)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore VC: UIViewController) -> UIViewController? {
        guard let VCIndex = orderedVCs.firstIndex(of: VC) else {
            return nil
        }
        
        let previousIndex = VCIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedVCs.count > previousIndex else {
            return nil
        }
        
        return orderedVCs[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter VC: UIViewController) -> UIViewController? {
        guard let VCIndex = orderedVCs.firstIndex(of: VC) else {
            return nil
        }
        
        let nextIndex = VCIndex + 1
        
        guard orderedVCs.count != nextIndex else {
            return nil
        }
        
        guard orderedVCs.count > nextIndex else {
            return nil
        }
        
        return orderedVCs[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentVC = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedVCs.firstIndex(of: pageContentVC)!
    }
}
