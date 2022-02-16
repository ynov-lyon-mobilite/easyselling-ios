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

    @nonobjc public class func fetchRequestById(id: String) -> Vehicle? {
        let fetch = NSFetchRequest<Vehicle>(entityName: "Vehicle")
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
