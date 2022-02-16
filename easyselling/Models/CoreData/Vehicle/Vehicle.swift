//
//  Vehicle+CoreDataClass.swift
//  easyselling
//
//  Created by Valentin Mont School on 07/01/2022.
//
//

import Foundation
import CoreData

@objc(Vehicle)
public class Vehicle: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vehicle> {
        return NSFetchRequest<Vehicle>(entityName: "Vehicle")
    }

    @nonobjc public class func fetchRequestById(id: String) -> NSFetchRequest<Vehicle> {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Vehicle")
        let predicate = NSPredicate(format: "id = %@", id) // Specify your condition here

        fetch.predicate = predicate
        return NSFetchRequest<Vehicle>(entityName: "Vehicle")
    }

    @NSManaged public var brand: String
    @NSManaged public var id: String?
    @NSManaged public var license: String
    @NSManaged public var model: String
    @NSManaged public var type: String
    @NSManaged public var year: String

    var vehicleCategory: Vehicle.Category {
        .init(rawValue: type) ?? .car
    }
}
