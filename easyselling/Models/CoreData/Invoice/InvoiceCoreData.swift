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

    @nonobjc public class func fetchRequestById(id: String) -> InvoiceCoreData? {
        let fetch = NSFetchRequest<InvoiceCoreData>(entityName: "Invoice")
        let predicate = NSPredicate(format: "id = %@", id)

        fetch.predicate = predicate
        do {
            let results = try fetch.execute()
            return results.first
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

        return nil
    }

    @nonobjc public class func fetchRequestByTitle(title: String) -> InvoiceCoreData? {
        let fetch = NSFetchRequest<InvoiceCoreData>(entityName: "Invoice")
        let predicate = NSPredicate(format: "fileTitle = %@", title)

        fetch.predicate = predicate
        do {
            let results = try fetch.execute()
            return results.first
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

        return nil
    }

    @NSManaged public var id: String
    @NSManaged public var fileId: String
    @NSManaged public var fileTitle: String?
    @NSManaged public var fileData: Data?

    convenience init(id: String, fileTitle: String?, fileData: Data?, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = id
        self.fileTitle = fileTitle
        self.fileData = fileData
    }
}
