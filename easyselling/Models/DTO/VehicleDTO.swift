//
//  VehicleDTO.swift
//  easyselling
//
//  Created by Valentin Mont School on 16/02/2022.
//
import Foundation

struct VehicleDTO: Encodable, Equatable {
    var brand: String
    var licence: String
    var model: String
    var type: Vehicle.Category
    var year: String
}
