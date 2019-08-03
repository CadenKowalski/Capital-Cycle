//
//  AppDelegate.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/7/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import Firebase
import CoreData

var signedIn: Bool!
var userType: SignUp.UserType!
var weekActivitiesList: [[String]]!
var Week: [[String]]!
var camperInfo: [[String]]!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // Saves the current working context
    func SaveContext(ContextName: NSManagedObjectContext) {
        if ContextName.hasChanges {
            do {
                try ContextName.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Creates a record for a given entity
    func instantiateRecordForEntity(Entity: String, Context: NSManagedObjectContext) -> NSManagedObject? {
        let entityDescription = NSEntityDescription.entity(forEntityName: Entity, in: Context)
        let entityRecord = NSManagedObject(entity: entityDescription!, insertInto: Context)
        return entityRecord
    }
    
    // Returns the record for a given entity
    func fetchRecordsOfEntity(Entity: String, Context: NSManagedObjectContext) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity)
        var Record = [NSManagedObject]()
        do {
            let fetchResult = try Context.fetch(fetchRequest)
            Record = fetchResult as! [NSManagedObject]
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return Record
    }

    // Override point for customization after application launch.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configures Firebase in app
        FirebaseApp.configure()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return true }
        let Context = appDelegate.persistentContainer.viewContext
        let Schedules = fetchRecordsOfEntity(Entity: "Schedule", Context: Context)
        // Configures the Schedule core data entity
        if let Schedule = Schedules.first {
            weekActivitiesList = Schedule.value(forKey: "daily") as? [[String]]
            Week = Schedule.value(forKey: "overview") as? [[String]]
        } else if let Schedule = instantiateRecordForEntity(Entity: "Schedule", Context: Context) {
            if Schedule.value(forKey: "daily") == nil {
                Schedule.setValue([[""]], forKey: "daily")
                weekActivitiesList = [[""]]
            }
            
            if Schedule.value(forKey: "overview") == nil {
                Schedule.setValue([[""]], forKey: "overview")
                Week = [[""]]
            }
        }
        
        // Configures the User core data entity
        let Users = fetchRecordsOfEntity(Entity: "User", Context: Context)
        if let _ = Users.first {
            for User in Users {
                if User.value(forKey: "email") as? String == Auth.auth().currentUser?.email {
                    signedIn = User.value(forKey: "signedIn") as? Bool
                    switch User.value(forKey: "type") as? String {
                    case "None":
                        userType = SignUp.UserType.none
                    case "Camper":
                        userType = .camper
                    case "Parent":
                        userType = .parent
                    case "Counselor":
                        userType = .counselor
                    default:
                        return true
                    }
                }
            }
        } else {
            signedIn = false
        }
        
        SaveContext(ContextName: Context)
        return true
    }

    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    func applicationWillTerminate(_ application: UIApplication) {
        // Saves the working context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let Context = appDelegate.persistentContainer.viewContext
        SaveContext(ContextName: Context)
    }

    // MARK: UISceneSession Lifecycle

    // Called when a new scene session is being created.
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // Called when the user discards a scene session.
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack

    // Sets up the container that the context is stored in
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Capital_Cycle")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
}
