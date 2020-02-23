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
    
    func updateContext(values: [String], _ refreshToken: String?, _ info: [[String]]?) {
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
                    Spreadsheet.setValue(dailyData, forKey: "dailyData")
                    
                case "overviewData":
                    Spreadsheet.setValue(overviewData, forKey: "overviewData")
                    
                case "camperInfo":
                    Spreadsheet.setValue(info!, forKey: "camperInfo")
                    
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
