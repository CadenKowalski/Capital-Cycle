//
//  CamperInfoPage.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/21/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import CoreData
import GoogleAPIClientForREST

class CamperInfoPage: UIViewController {

    // Storyboard outlets
    @IBOutlet weak var gradientView: CustomView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var camperInfoLblYConstraint: NSLayoutConstraint!
    @IBOutlet weak var accountSettingsImgView: CustomImageView!
    @IBOutlet weak var camperScrollViewYConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewDisplay: UIView!
    @IBOutlet weak var scrollViewDisplayHeight: NSLayoutConstraint!
    @IBOutlet weak var camperInfoView: UIView!
    @IBOutlet weak var camperName: UILabel!
    @IBOutlet weak var parentNameLbl: UILabel!
    @IBOutlet weak var parentPhoneLbl: UILabel!
    @IBOutlet weak var parentEmailLbl: UILabel!
    @IBOutlet weak var signedWaiverLbl: UILabel!
    //Code global vars
    static let Instance = CamperInfoPage()
    let spreadsheetID = "1alCW-eSX-lC6CUi0lbmNK7hpfkUhpOqhrbWZCBJgXuk"
    let Service = GTLRSheetsService()
    var camperBtns = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeLayout()
        fetchNumCampers()
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
            camperInfoLblYConstraint.constant = 15
        }

        // Readjusts the Y constraints relative to the gradient view height
        camperScrollViewYConstraint.constant = gradientView.frame.height + 10
        
        // Sets the profile image on the account settings button
        CamperInfoPage.Instance.accountSettingsImgView = accountSettingsImgView
        setProfileImg()
        
        // Sets the API key for the GTLR Service so that the app can access the spreadhseet without credentials
        Service.apiKey = "AIzaSyBIdPHR_nqgL9G6fScmlcPMReBM5PmtVD8"
    }
    
    // Sets the profile image on the account settings button
    func setProfileImg() {
        accountSettingsImgView.image = user.profileImg
    }
    
    // MARK: Camper Info Data

    // Fetches the number of campers
    func fetchNumCampers() {
        let Range = "Camper Info!F2"
        let Query = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: spreadsheetID, range: Range)
        Service.executeQuery(Query, delegate: self, didFinish: #selector(setNumCampers(Ticket:finishedWithObject:Error:)))
    }
    
    // Sets the number of campers
    @objc func setNumCampers(Ticket: GTLRServiceTicket, finishedWithObject Result: GTLRSheets_ValueRange, Error: NSError?) {
        if Reachability.isConnectedToNetwork() {
            fetchCamperInfo(numCampers: (Result.values![0][0] as! String))
        } else {
            fetchCamperInfo(numCampers: String(camperInfo!.count))
        }
    }
    
    // Fetches the camper info data
    func fetchCamperInfo(numCampers: String) {
        let Range = "Camper Info!A2:E\(numCampers)"
        let Query = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: spreadsheetID, range: Range)
        Service.executeQuery(Query, delegate: self, didFinish: #selector(addCamperInfo(Ticket:finishedWithObject:Error:)))
    }
    
    // Adds the camper info to a list of UIButtons
    @objc func addCamperInfo(Ticket: GTLRServiceTicket, finishedWithObject Result: GTLRSheets_ValueRange, Error: NSError?) {
        if Reachability.isConnectedToNetwork() {
            camperInfo = Result.values as? [[String]]
            updateContext()
        }
        
        createBtn(numBtns: (camperInfo?.count)!)
    }
    
    // MARK: Display Camper Info
    
    func createBtn(numBtns: Int) {
        for camper in 0..<numBtns {
            let camperBtn: UIButton
            if camperBtns.count == 0 {
                camperBtn = UIButton(frame: CGRect(x: 16, y:  0, width: 150, height: 40))
            } else {
                camperBtn = UIButton(frame: CGRect(x: 16, y:  camperBtns[camper - 1].frame.maxY, width: 150, height: 40))
            }
            
            camperBtn.setTitle("\(camperInfo[camper][0])", for: .normal)
            camperBtn.setTitleColor(UIColor(named: "LabelColor"), for: .normal)
            camperBtn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
            camperBtn.contentHorizontalAlignment = .left
            camperBtn.addTarget(self, action: #selector(displayCamperInfo(_:)), for: .touchUpInside)
            scrollViewDisplay.addSubview(camperBtn)
            camperBtns.append(camperBtn)
        }
        
        if (camperBtns.count * 40 + 25) > 668 {
            scrollViewDisplayHeight.constant = CGFloat(camperBtns.count * 40) + 25
        } else {
            scrollViewDisplayHeight.constant = view.frame.height - (gradientView.frame.height + 35)
        }
    }
    
    @objc func displayCamperInfo(_ sender: UIButton) {
        camperBtns.first?.setTitleColor(UIColor(named: "ViewColor"), for: .normal)
        camperInfoView.isHidden = false
        scrollViewDisplay.bringSubviewToFront(camperInfoView)
        camperName.text = "\(camperInfo[camperBtns.firstIndex(of: sender)!][0])"
        parentNameLbl.text = "\(camperInfo[camperBtns.firstIndex(of: sender)!][1])"
        parentPhoneLbl.text = "\(camperInfo[camperBtns.firstIndex(of: sender)!][2])"
        parentEmailLbl.text = "\(camperInfo[camperBtns.firstIndex(of: sender)!][3])"
        signedWaiverLbl.text = "\(camperInfo[camperBtns.firstIndex(of: sender)!][4])"
        if user.prefersHapticFeedback! {
            let feedbackGenerator = UISelectionFeedbackGenerator()
            feedbackGenerator.selectionChanged()
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
            Spreadsheet.setValue(camperInfo, forKey: "camperInfo")
            try Context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    // MARK: Dismiss
    
    @IBAction func dismissCamperInfoView(_ sender: UIButton) {
        camperInfoView.isHidden = true
        camperBtns.first?.setTitleColor(UIColor(named: "LabelColor"), for: .normal)
    }
}
