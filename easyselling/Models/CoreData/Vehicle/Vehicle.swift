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

    func toDTO() -> VehicleDTO {
        return VehicleDTO(brand: self.brand, licence: self.licence, model: self.model, type: self.type, year: self.year)
    }

    func toCoreDataObject(in context: NSManagedObjectContext) -> VehicleCoreData {
        return VehicleCoreData(id: self.id, brand: self.brand, licence: self.licence, model: self.model, type: self.type.rawValue, year: self.year, in: context)
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
