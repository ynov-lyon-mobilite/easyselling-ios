//
//  Vehicle.swift
//  easyselling
//
//  Created by Théo Tanchoux on 07/11/2021.
//

import Foundation

struct VehicleDTO: Codable, Equatable, Identifiable {
    var id: String?
    var brand: String
    var model: String
    var license: String
    var type: Vehicle.Category
    var year: String
}
