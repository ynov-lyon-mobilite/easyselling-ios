//
//  InvoiceCoreData.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 09/03/2022.
//

import Foundation

import CoreData

@objc(Invoice)
public class InvoiceCoreData: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<InvoiceCoreData> {
        return NSFetchRequest<InvoiceCoreData>(entityName: "Invoice")
    }

    @nonobjc public class func fetchRequestById(id: Int) -> InvoiceCoreData? {
        let fetch = NSFetchRequest<InvoiceCoreData>(entityName: "Invoice")
        let predicate = NSPredicate(format: "id = %d", id)

        fetch.predicate = predicate
        do {
            let results = try fetch.execute()
            return results.first
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

        return nil
    }

    @NSManaged public var id: Int16
    @NSManaged public var vehicle: String
    @NSManaged public var file: String
    @NSManaged public var dateCreated: String
    @NSManaged public var dateUpdated: String?

    convenience init(id: Int16, vehicle: String, file: String, dateCreated: String, dateUpdated: String?) {
        self.init(context: mainContext)
        self.id = id
        self.vehicle = vehicle
        self.file = file
        self.dateCreated = dateCreated
        self.dateUpdated = dateUpdated
    }
}
