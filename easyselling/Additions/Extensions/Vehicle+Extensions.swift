//
//  Vehicle+Extensions.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 01/04/2022.
//

import Foundation
import UIKit
import SwiftUI

extension Vehicle {
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

    static var placeholderCar: Vehicle {
        .init(id: UUID().uuidString, brand: "Marque", model: "Model", licence: "Licence", type: .car, year: "0000")
    }

    static var placeholderMoto: Vehicle {
        .init(id: UUID().uuidString, brand: "Marque", model: "Model", licence: "Licence", type: .moto, year: "0000")
    }
}
