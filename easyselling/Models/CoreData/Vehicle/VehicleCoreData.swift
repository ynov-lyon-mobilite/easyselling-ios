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
public class VehicleCoreData: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VehicleCoreData> {
        return NSFetchRequest<VehicleCoreData>(entityName: "Vehicle")
    }

    @nonobjc public class func fetchRequestById(id: String) -> VehicleCoreData? {
        let fetch = NSFetchRequest<VehicleCoreData>(entityName: "Vehicle")
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
    @NSManaged public var id: String
    @NSManaged public var license: String
    @NSManaged public var model: String
    @NSManaged public var type: String
    @NSManaged public var year: String

    convenience init(id: String, brand: String, license: String, model: String, type: String, year: String, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = id
        self.brand = brand
        self.license = license
        self.model = model
        self.type = type
        self.year = year
    }

    func update(withVehicle data: Vehicle) {
        self.id = data.id
        self.brand = data.brand
        self.license = data.license
        self.model = data.model
        self.type = data.type.rawValue
        self.year = data.year
    }
}
