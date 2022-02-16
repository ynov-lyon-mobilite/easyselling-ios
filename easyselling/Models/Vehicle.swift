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
    var id: String?
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
    }
}
