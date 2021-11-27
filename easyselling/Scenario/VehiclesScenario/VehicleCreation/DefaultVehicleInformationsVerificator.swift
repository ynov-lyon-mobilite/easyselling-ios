//
//  VehicleInformationsVerificator.swift
//  easyselling
//
//  Created by Valentin Mont School on 17/10/2021.
//

import Foundation

protocol VehicleInformationsVerificator {
    func verifyInformations(vehicle: Vehicle) throws
}

class DefaultVehicleInformationsVerificator: VehicleInformationsVerificator {
    func verifyInformations(vehicle: Vehicle) throws {
        let vehicleVerificator = DefaultVehicleVerificator()

        switch true {
            case vehicle.license.isEmpty
                || vehicle.brand.isEmpty
                || vehicle.model.isEmpty: throw VehicleCreationError.emptyField
            case vehicleVerificator.verifyLicenseFormat(license: vehicle.license): throw VehicleCreationError.incorrectLicenseFormat
            case vehicleVerificator.verifyLicenseSize(license: vehicle.license): throw VehicleCreationError.incorrectLicenseSize
            case vehicle.year.count != 4: throw VehicleCreationError.incorrectYear
            default: break
        }
    }
}

enum VehicleCreationError: Equatable, LocalizedError {
    case emptyField
    case incorrectYear
    case incorrectLicenseFormat
    case incorrectLicenseSize

    var description: String {
        switch self {
            case .emptyField: return L10n.CreateVehicle.Error.emptyField
            case .incorrectYear: return L10n.CreateVehicle.Error.incorrectYear
            case .incorrectLicenseFormat: return L10n.CreateVehicle.Error.incorrectLicenseFormat
            case .incorrectLicenseSize: return L10n.CreateVehicle.Error.incorrectLicenseSize
        }
    }
}
