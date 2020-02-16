//
//  GoogleFunctions.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 2/15/20.
//  Copyright © 2020 Caden Kowalski. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST
import CoreData

class GoogleFunctions: NSObject {
    
    // MARK: Global Variables
    
    // Code global vars
    let service = GTLRSheetsService()
    let unsecureSpreadsheetID = "1alCW-eSX-lC6CUi0lbmNK7hpfkUhpOqhrbWZCBJgXuk"
    
    // MARK: Google Functions
    
    func unsecureFetchData() {
        service.apiKey = "AIzaSyBIdPHR_nqgL9G6fScmlcPMReBM5PmtVD8"
        let Query = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: unsecureSpreadsheetID, range: "Schedule Data!A2:M13")
        service.executeQuery(Query, delegate: self, didFinish: #selector(returnData(Ticket:finishedWithObject:Error:)))
    }
    
    @objc func returnData(Ticket: GTLRServiceTicket, finishedWithObject Result: GTLRSheets_ValueRange, Error: NSError?) {
        if Error == nil {
            guard let results = Result.values! as? [[String]] else {
                return
            }
            
            if Reachability.isConnectedToNetwork() {
                weekActivitiesList = Array(results[0...4])
                week = Array(results[7...11])
                updateContext()
            }
        } else {
            print(Error!.localizedDescription)
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
            Spreadsheet.setValue(week, forKey: "overviewData")
            try Context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
