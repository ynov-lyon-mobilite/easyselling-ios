//
//  VehicleInformationsVerificator.swift
//  easyselling
//
//  Created by Valentin Mont School on 17/10/2021.
//

import Foundation

protocol VehicleInformationsProtocol {
    func checkingInformations(vehicle: VehicleInformations) -> Bool
}

class VehicleInformationsVerificator: VehicleInformationsProtocol {
    func checkingInformations(vehicle: VehicleInformations) -> Bool {
        guard vehicle.immatriculation.count == 8,
              vehicle.licenceNumber.count == 14,
              vehicle.year < 100 else {
            return false
        }
        return true
    }
}

struct VehicleInformations: Equatable, Encodable {
    var licenceNumber: String
    var brand: String
    var immatriculation: String
    var type: VehicleType
    var year: Int
    var model: String
}

enum VehicleType: Encodable {
    case car
    case motorcycle
}
