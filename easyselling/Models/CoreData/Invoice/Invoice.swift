//
//  Invoice.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 26/01/2022.
//
//

import Foundation
import CoreData

@objc(Invoice)
public class Invoice: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Invoice> {
        return NSFetchRequest<Invoice>(entityName: "Invoice")
    }

    @NSManaged public var id: Int16
    @NSManaged public var vehicle: String?
    @NSManaged public var file: String?
    @NSManaged public var dateCreated: String?
    @NSManaged public var dateUpdated: String?
}
