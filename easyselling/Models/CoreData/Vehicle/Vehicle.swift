//
//  Vehicle.swift
//  easyselling
//
//  Created by Valentin Mont School on 16/02/2022.
//

import Foundation
import UIKit
import SwiftUI

struct Vehicle: Decodable {
    var brand: String
    var id: String?
    var license: String
    var model: String
    var type: Category
    var year: String

    static func toEncodableStruct (vehicle: Vehicle) -> VehicleDTO? {
        return VehicleDTO(brand: vehicle.brand, license: vehicle.license, model: vehicle.model, type: vehicle.type.rawValue, year: vehicle.year)
    }

    static func toCoreDataObject (vehicle: Vehicle) -> VehicleCoreData {
        return VehicleCoreData(id: vehicle.id ?? "", brand: vehicle.brand, license: vehicle.license, model: vehicle.model, type: vehicle.type.rawValue, year: vehicle.year)
    }

    static func fromCoreDataToObject (vehicle: VehicleCoreData) -> Vehicle {
        let type = Vehicle.Category(rawValue: vehicle.type) ?? .car
        return Vehicle(brand: vehicle.brand, id: vehicle.id, license: vehicle.license, model: vehicle.model, type: type, year: vehicle.year)
    }
}

extension Vehicle {
    var image: UIImage {
        switch type {
            case .car: return Asset.Icons.car.image
            case .moto: return Asset.Icons.moto.image
            }
        }
        var imageColor: Color {
            switch type {
            case .car: return Asset.Colors.secondary.swiftUIColor
            case .moto: return Asset.Colors.primary.swiftUIColor
            }
        }
        var color: Color {
            switch type {
            case .car: return Asset.Colors.lightPurple.swiftUIColor
            case .moto: return Asset.Colors.lightBlue.swiftUIColor
            }
        }

        enum Category: String, Codable {
          case car, moto

          var description: String {
            switch self {
            case .car:
                return L10n.Vehicles.car
            case .moto:
                return L10n.Vehicles.moto
            }
          }
            static func from(category: String) -> Self {
                return .init(rawValue: category) ?? .car
            }
        }
}
