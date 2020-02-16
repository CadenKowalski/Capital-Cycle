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
    
    func updateContext() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let Context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Spreadsheet")
        do {
            let fetchResults = try Context.fetch(fetchRequest)
            let Spreadsheet = fetchResults.first as! NSManagedObject
            Spreadsheet.setValue(weekActivitiesList, forKey: "dailyData")
            Spreadsheet.setValue(week, forKey: "overviewData")
            Spreadsheet.setValue(camperInfo, forKey: "camperInfo")
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
                case "dailyData":
                    weekActivitiesList = Spreadsheet.value(forKey: value) as? [[String]]
                    
                case "overviewData":
                    week = Spreadsheet.value(forKey: value) as? [[String]]
                    
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
