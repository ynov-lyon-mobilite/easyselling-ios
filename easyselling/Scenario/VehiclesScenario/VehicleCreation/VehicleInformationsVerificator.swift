//
//  VehicleInformationsVerificator.swift
//  easyselling
//
//  Created by Valentin Mont School on 17/10/2021.
//

import Foundation

protocol VehicleInformationsProtocol {
    func verifyInformations(vehicle: VehicleInformations) throws -> VehicleInformations
}

class VehicleInformationsVerificator: VehicleInformationsProtocol {
    func verifyInformations(vehicle: VehicleInformations) throws -> VehicleInformations {
        switch true {
            case vehicle.license.isEmpty
                || vehicle.brand.isEmpty
                || vehicle.model.isEmpty: throw VehicleCreationError.emptyField
            case vehicle.license.count != 9: throw VehicleCreationError.incorrectLicense
            case vehicle.year.count != 4: throw VehicleCreationError.incorrectYear
            default: return vehicle
        }
    }
}

enum VehicleCreationError: Equatable, LocalizedError {
    case emptyField
    case incorrectYear
    case incorrectLicense

    var description: String {
        switch self {
            case .emptyField: return L10n.CreateVehicle.Error.emptyField
            case .incorrectYear: return L10n.CreateVehicle.Error.incorrectYear
            case .incorrectLicense: return L10n.CreateVehicle.Error.incorrectLicense
        }
    }
}
