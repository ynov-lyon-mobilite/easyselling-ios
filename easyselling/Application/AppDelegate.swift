//
//  AppDelegate.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 14/10/2021.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        TaskSequencer.shared.tasks.append(MyVehicleTask())
        TaskSequencer.shared.proccess()

        let taskInvoicesPost  = TaskInvoicesPost(invoices: [InvoiceDTO(id: 12, vehicle: "test", file: "test", dateCreated: "test", dateUpdated: "test")])
        taskInvoicesPost.insertInvoices()
        TaskInvoicesGetter().getInvoices() 

        return true
    }
}

var mainContext: NSManagedObjectContext = {
    let container = NSPersistentContainer(name: "easyselling")
    container.loadPersistentStores(completionHandler: { _, error in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return container.viewContext
}()

func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
