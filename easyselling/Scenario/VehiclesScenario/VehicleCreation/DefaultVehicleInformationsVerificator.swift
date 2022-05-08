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
            case vehicle.licence.isEmpty
                || vehicle.brand.isEmpty
                || vehicle.model.isEmpty: throw VehicleCreationError.emptyField
            case vehicle.year.count != 4: throw VehicleCreationError.incorrectYear
            default: break
        }
    }

    func verifyLicence(_ licence: String) throws {
        let vehicleVerificator = DefaultVehicleVerificator()

        try vehicleVerificator.verifylicenceFormat(licence: licence)
        try vehicleVerificator.verifylicenceSize(licence: licence)
    }
}

enum VehicleCreationError: Equatable, LocalizedError {
    case emptyField
    case incorrectYear
    case incorrectlicenceFormat
    case incorrectlicenceSize
    case unchosenType
    case unchosenVehicleBrandAndModel

    var errorDescription: String? {
        switch self {
            case .emptyField: return L10n.CreateVehicle.Error.emptyField
            case .incorrectYear: return L10n.CreateVehicle.Error.incorrectYear
            case .incorrectlicenceFormat: return L10n.CreateVehicle.Error.incorrectlicenceFormat
            case .incorrectlicenceSize: return L10n.CreateVehicle.Error.incorrectlicenceSize
            case .unchosenType: return L10n.CreateVehicle.Error.unchosenType
            case .unchosenVehicleBrandAndModel: return L10n.CreateVehicle.Error.unchosenVehiculeBrandAndModel
        }
    }
}
