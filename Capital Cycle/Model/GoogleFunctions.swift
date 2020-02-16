//
//  GoogleFunctions.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 2/15/20.
//  Copyright © 2020 Caden Kowalski. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

class GoogleFunctions: NSObject {
    
    // MARK: Global Variables
    
    // Code global vars
    let service = GTLRSheetsService()
    let unsecureSpreadsheetID = "1alCW-eSX-lC6CUi0lbmNK7hpfkUhpOqhrbWZCBJgXuk"
    
    // MARK: Google Functions
    
    func unsecureFetchDataWithConnection() {
        service.apiKey = "AIzaSyBIdPHR_nqgL9G6fScmlcPMReBM5PmtVD8"
        let Query = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: unsecureSpreadsheetID, range: "Schedule Data!A2:M13")
        service.executeQuery(Query, delegate: self, didFinish: #selector(unsecureReturnData(Ticket:finishedWithObject:Error:)))
    }
    
    @objc func unsecureReturnData(Ticket: GTLRServiceTicket, finishedWithObject Result: GTLRSheets_ValueRange, Error: NSError?) {
        if Error == nil {
            guard let results = Result.values! as? [[String]] else {
                return
            }
            
            weekActivitiesList = Array(results[0...4])
            week = Array(results[7...11])
            coreDataFunctions.updateContext()
        } else {
            print(Error!.localizedDescription)
        }
    }
    
    func fetchDataWithoutConnection() {
        coreDataFunctions.fetchData(contextValues: ["dailyData", "overviewData"])
    }
}
