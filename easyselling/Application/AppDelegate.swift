//
//  AppDelegate.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 14/10/2021.
//

import UIKit
import CoreData
import Firebase
import netfox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
#if DEBUG
        NFX.sharedInstance().start()
#endif

        return true
    }
}
// MARK: - Application

func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

// MARK: - CoreData Stack

// MARK: Public

public var mainContext: NSManagedObjectContext = {
    persistentContainer = NSPersistentContainer(name: "easyselling")
    persistentContainer.loadPersistentStores(completionHandler: { _, error in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return persistentContainer.viewContext
}()

public func deleteAllEntities() {
    let entities = persistentContainer.managedObjectModel.entities
    for entity in entities {
        delete(entityName: entity.name!)
    }
}

// MARK: Private

private var persistentContainer: NSPersistentContainer!

private func delete(entityName: String) {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    do {
        try persistentContainer.viewContext.execute(deleteRequest)
    } catch let error as NSError {
        debugPrint(error)
    }
}
