//
//  VehicleDTO.swift
//  easyselling
//
//  Created by Maxence on 07/01/2022.
//

import Foundation

struct VehicleDTO: Encodable {
    var brand: String
    var model: String
    var license: String
    var type: Vehicle.Category
    var year: String
}
