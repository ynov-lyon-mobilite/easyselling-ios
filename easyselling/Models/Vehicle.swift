//
//  Vehicle.swift
//  easyselling
//
//  Created by Théo Tanchoux on 07/11/2021.
//

import Foundation
import UIKit
import SwiftUI

struct Vehicle: Codable, Equatable, Identifiable {
    var id: String
    var brand: String
    var model: String
    var license: String
    var type: Category
    var year: String

    enum CodingKeys: String, CodingKey {
        case brand, model, license, type, year
        case id = "_id"
    }

    var image: UIImage {
        switch type {
        case .car: return Asset.Icons.car.image
        case .moto: return Asset.Icons.moto.image
        case .unknow: return UIImage()
        }
    }
    var imageColor: Color {
        switch type {
        case .car: return Asset.Colors.primary.swiftUIColor
        case .moto: return Asset.Colors.secondary.swiftUIColor
        case .unknow: return .white
        }
    }
    var color: Color {
        switch type {
        case .car: return Asset.Colors.lightPurple.swiftUIColor
        case .moto: return Asset.Colors.lightBlue.swiftUIColor
        case .unknow: return .white
        }
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

extension Vehicle {
    static var placeholderCar: Vehicle {
        .init(id: UUID().uuidString, brand: "Marque", model: "Model", license: "Licence", type: .car, year: "0000")
    }

    static var placeholderMoto: Vehicle {
        .init(id: UUID().uuidString, brand: "Marque", model: "Model", license: "Licence", type: .moto, year: "0000")
    }
}
