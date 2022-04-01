//
//  Vehicle.swift
//  easyselling
//
//  Created by Théo Tanchoux on 07/11/2021.
//

import Foundation

struct Vehicle: Codable, Equatable, Identifiable {
    var id: String
    var brand: String
    var model: String
    var licence: String
    var type: Category
    var year: String

    enum CodingKeys: String, CodingKey {
        case brand, model, licence, type, year
        case id = "_id"
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
