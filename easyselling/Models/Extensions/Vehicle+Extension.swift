//
//  Vehicle+Extension.swift
//  easyselling
//
//  Created by Valentin Mont School on 07/01/2022.
//

import Foundation
import CoreData
import UIKit
import SwiftUI

extension Vehicle {

    convenience init(brand: String, model: String, license: String, type: String, year: String) {
        self.init()
    }

    var image: UIImage {
        switch Category.from(category: type) {
        case .car: return Asset.Icons.car.image
        case .moto: return Asset.Icons.moto.image
        }
    }
    var imageColor: Color {
        switch Category.from(category: type) {
        case .car: return Asset.Colors.secondary.swiftUIColor
        case .moto: return Asset.Colors.primary.swiftUIColor
        }
    }
    var color: Color {
        switch Category.from(category: type) {
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
