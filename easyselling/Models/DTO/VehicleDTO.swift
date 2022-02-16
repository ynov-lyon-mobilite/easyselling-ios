//
//  VehicleDTO.swift
//  easyselling
//
//  Created by Valentin Mont School on 16/02/2022.
//

import Foundation

struct VehicleDTO: Encodable {
    var brand: String
    var license: String
    var model: String
    var type: String
    var year: String
}
