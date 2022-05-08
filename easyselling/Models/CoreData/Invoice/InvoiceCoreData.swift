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

    func toObject () -> Invoice {
        return Invoice(id: self.id, file: FileResponse(filename: self.fileTitle ?? ""), label: self.fileLabel, mileage: self.fileMileage, date: self.fileDate, vehicle: self.fileVehicle)
    }

    @NSManaged public var id: String
    @NSManaged public var fileId: String
    @NSManaged public var fileTitle: String?
    @NSManaged public var fileData: Data?
    @NSManaged public var fileLabel: String
    @NSManaged public var fileMileage: Int
    @NSManaged public var fileDate: Date
    @NSManaged public var fileVehicle: String

    convenience init(id: String, fileTitle: String?, fileData: Data?, fileLabel: String, fileMileage: Int, fileDate: Date, fileVehicle: String, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = id
        self.fileTitle = fileTitle
        self.fileData = fileData
        self.fileLabel = fileLabel
        self.fileMileage = fileMileage
        self.fileDate = fileDate
        self.fileVehicle = fileVehicle
    }
}
