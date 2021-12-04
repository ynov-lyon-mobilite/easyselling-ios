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
    var image: UIImage {
        switch type {
        case .car: return Asset.car.image
        case .moto: return Asset.moto.image
        }
    }
    var imageColor: Color {
        switch type {
        case .car: return Asset.darkPurple.swiftUIColor
        case .moto: return Asset.darkBlue.swiftUIColor
        }
    }
    var color: Color {
        switch type {
        case .car: return Asset.lightPurple.swiftUIColor
        case .moto: return Asset.lightBlue.swiftUIColor
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
