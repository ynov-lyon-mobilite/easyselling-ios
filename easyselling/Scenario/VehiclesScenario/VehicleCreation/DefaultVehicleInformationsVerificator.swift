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
        switch true {
            case vehicle.license.isEmpty
                || vehicle.brand.isEmpty
                || vehicle.model.isEmpty: throw VehicleCreationError.emptyField
            case verifyLicenseSize(vehicle: vehicle): throw VehicleCreationError.incorrectLicenseSize
            case verifyLicenseFormat(vehicle: vehicle): throw VehicleCreationError.incorrectLicenseFormat
            case vehicle.year.count != 4: throw VehicleCreationError.incorrectYear
            default: break
        }
    }

    func verifyLicenseSize(vehicle: Vehicle) -> Bool {
        let isNewLicense = !vehicle.license[String.Index(utf16Offset: 0, in: vehicle.license)].isNumber

        switch true {
        case vehicle.license.count == 7 && isNewLicense:
            return false
        case vehicle.license.count == 8 && !isNewLicense:
            return false
        case vehicle.license.count != 7 && vehicle.license.count != 8:
            return true
        case vehicle.license.count != 7 && isNewLicense:
            return true
        case vehicle.license.count != 8 && !isNewLicense:
            return true
        default: return true
        }
    }

    func verifyLicenseFormat(vehicle: Vehicle) -> Bool {
        let isNewLicense = vehicle.license.count == 7

        for index in 0...vehicle.license.count - 1 {
            let isNumber = vehicle.license[String.Index(utf16Offset: index, in: vehicle.license)].isNumber

            switch true {
            case index < (isNewLicense ? 2 : 3):
                if (isNumber && isNewLicense) || (!isNumber && !isNewLicense) {
                    return true
                }
            case index < (isNewLicense ? 5 : 6):
                if (!isNumber && isNewLicense) || (isNumber && !isNewLicense) {
                    return true
                }
            case index < (isNewLicense ? 7 : 8):
                if (isNumber && isNewLicense) || (!isNumber && !isNewLicense) {
                    return true
                }
            default: break
            }
        }
        return false
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
