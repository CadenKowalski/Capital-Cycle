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
    func fetchRecordOfEntity(Entity: String, Context: NSManagedObjectContext) -> [NSManagedObject] {
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
        
        // Either instantiates a record for the Authentication entity or sets the attribute signedIn to its core data value if one already exists
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return true }
        let Context = appDelegate.persistentContainer.viewContext
        
        let signedInRecord = fetchRecordOfEntity(Entity: "Authentication", Context: Context)
        if let signedInCurrentState = signedInRecord.first {
            signedIn = signedInCurrentState.value(forKey: "signedIn") as? Bool
        } else if let createSignedInRecord = instantiateRecordForEntity(Entity: "Authentication", Context: Context) {
            createSignedInRecord.setValue(false, forKey: "signedIn")
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
