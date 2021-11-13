//
//  Vehicle.swift
//  easyselling
//
//  Created by Théo Tanchoux on 07/11/2021.
//

import Foundation

struct VehicleInformations: Codable, Equatable, Identifiable {
    var id: String = ""
    var brand: String
    var model: String
    var license: String
    var type: Category
    var year: String
    
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
