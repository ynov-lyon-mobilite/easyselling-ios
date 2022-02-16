//
//  Vehicle.swift
//  easyselling
//
//  Created by Valentin Mont School on 16/02/2022.
//

import Foundation
import UIKit
import SwiftUI

class Vehicle {
    var brand: String
    var id: String?
    var license: String
    var model: String
    var type: Category
    var year: String

    init(id: String, brand: String, license: String, model: String, type: String, year: String) {
        self.id = id
        self.brand = brand
        self.license = license
        self.model = model
        self.type = Category.from(category: type)
        self.year = year
    }

    static func toEncodableStruct (vehicle: Vehicle) -> VehicleDTO? {
        return VehicleDTO(brand: vehicle.brand, license: vehicle.license, model: vehicle.model, type: vehicle.type.rawValue, year: vehicle.year)
    }

    static func toCoreDataObject (vehicle: VehicleResponse) -> VehicleCoreData {
        return VehicleCoreData(id: vehicle.id, brand: vehicle.brand, license: vehicle.license, model: vehicle.model, type: vehicle.type, year: vehicle.year)
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

struct VehicleResponse: Decodable {
    var brand: String
    var id: String
    var license: String
    var model: String
    var type: String
    var year: String
}
