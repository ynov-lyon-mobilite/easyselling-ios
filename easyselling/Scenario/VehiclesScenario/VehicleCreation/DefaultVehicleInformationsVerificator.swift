//
//  VehicleInformationsVerificator.swift
//  easyselling
//
//  Created by Valentin Mont School on 17/10/2021.
//

import Foundation

protocol VehicleInformationsVerificator {
    func verifyInformations(vehicle: VehicleDTO) throws
    func verifyLicence(_ licence: String) throws
}

class DefaultVehicleInformationsVerificator: VehicleInformationsVerificator {
    func verifyInformations(vehicle: VehicleDTO) throws {
        switch true {
            case vehicle.license.isEmpty
                || vehicle.brand.isEmpty
                || vehicle.model.isEmpty: throw VehicleCreationError.emptyField
            case vehicle.year.count != 4: throw VehicleCreationError.incorrectYear
            default: break
        }
    }

    func verifyLicence(_ licence: String) throws {
        let vehicleVerificator = DefaultVehicleVerificator()

        try vehicleVerificator.verifyLicenseFormat(license: licence)
        try vehicleVerificator.verifyLicenseSize(license: licence)
    }
}

enum VehicleCreationError: Equatable, LocalizedError {
    case emptyField
    case incorrectYear
    case incorrectLicenseFormat
    case incorrectLicenseSize
    case unchosenType

    var errorDescription: String? {
        switch self {
            case .emptyField: return L10n.CreateVehicle.Error.emptyField
            case .incorrectYear: return L10n.CreateVehicle.Error.incorrectYear
            case .incorrectLicenseFormat: return L10n.CreateVehicle.Error.incorrectLicenseFormat
            case .incorrectLicenseSize: return L10n.CreateVehicle.Error.incorrectLicenseSize
            case .unchosenType: return "Vous devez choisir un type de véhicule"
        }
    }
}
