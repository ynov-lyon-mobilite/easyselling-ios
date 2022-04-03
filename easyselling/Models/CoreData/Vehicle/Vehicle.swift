//
//  Vehicle.swift
//  easyselling
//
//  Created by Valentin Mont School on 16/02/2022.
//
import Foundation
import UIKit
import SwiftUI
import CoreData

struct Vehicle: Decodable, Equatable {
    var id: String
    var brand: String
    var model: String
    var licence: String
    var type: Category
    var year: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case brand
        case model
        case licence
        case type
        case year
    }

    init(id: String, brand: String, model: String, licence: String, type: Category, year: String) {
        self.id = id
        self.brand = brand
        self.licence = licence
        self.model = model
        self.type = type
        self.year = year
    }

    func toDTO() -> VehicleDTO {
        return VehicleDTO(brand: self.brand, licence: self.licence, model: self.model, type: self.type, year: self.year)
    }

    static func toVehicle(vehicle: VehicleCoreData) -> Vehicle {
        let type = Vehicle.Category(rawValue: vehicle.type) ?? .car
        return Vehicle(id: vehicle.id, brand: vehicle.brand, model: vehicle.model, licence: vehicle.licence, type: type, year: vehicle.year)
    }

    static func toCoreDataObject(vehicle: Vehicle, in context: NSManagedObjectContext) -> VehicleCoreData {
        return VehicleCoreData(id: vehicle.id, brand: vehicle.brand, licence: vehicle.licence, model: vehicle.model, type: vehicle.type.rawValue, year: vehicle.year, in: context)
    }

    enum Category: String, Codable {
      case car, moto, unknow

      var description: String {
        switch self {
        case .car:
            return L10n.Vehicles.car
        case .moto:
            return L10n.Vehicles.moto
        case .unknow:
            return ""
        }
      }
    }
}
