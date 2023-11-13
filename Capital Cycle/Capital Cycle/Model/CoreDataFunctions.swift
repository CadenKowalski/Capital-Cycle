//
//  CoreDataFunctions.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 2/16/20.
//  Copyright © 2020 Caden Kowalski. All rights reserved.
//

import UIKit
import CoreData

struct CoreDataFunctions {
    
    // MARK: Core Data Functions
    
    // Updates core data values
    func updateContext(values: [String], _ refreshToken: String?, _ dData: [[String]]?, _ oData: [[String]]?, _ info: [[String]]?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let Context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Spreadsheet")
        do {
            let fetchResults = try Context.fetch(fetchRequest)
            let Spreadsheet = fetchResults.first as! NSManagedObject
            for value in values {
                switch value {
                case "refresh_token":
                    if let refreshToken = refreshToken {
                        Spreadsheet.setValue(refreshToken, forKey: "refresh_token")
                    }
                    
                case "dailyData":
                    if let dData = dData {
                        Spreadsheet.setValue(dData, forKey: "dailyData")
                    }
                    
                case "overviewData":
                    if let oData = oData {
                        Spreadsheet.setValue(oData, forKey: "overviewData")
                    }
                    
                case "camperInfo":
                    if let info = info {
                        Spreadsheet.setValue(info, forKey: "camperInfo")
                    }
                    
                default:
                    return
                }
            }
            
            try Context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    // Fetches core data values
    func fetchData(contextValues: [String]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let Context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Spreadsheet")
        do {
            let fetchResults = try Context.fetch(fetchRequest)
            let Spreadsheet = fetchResults.first as! NSManagedObject
            for value in contextValues {
                switch value {
                case "refresh_token":
                    refresh_token = Spreadsheet.value(forKey: value) as? String
                    
                case "dailyData":
                    dailyData = Spreadsheet.value(forKey: value) as? [[String]]
                    
                case "overviewData":
                    overviewData = Spreadsheet.value(forKey: value) as? [[String]]
                    
                case "camperInfo":
                    camperInfo = Spreadsheet.value(forKey: value) as? [[String]]
                    
                default:
                    return
                }
            }
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
