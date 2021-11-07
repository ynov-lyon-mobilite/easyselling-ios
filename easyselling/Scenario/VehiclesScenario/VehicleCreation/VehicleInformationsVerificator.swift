//
//  VehicleInformationsVerificator.swift
//  easyselling
//
//  Created by Valentin Mont School on 17/10/2021.
//

import Foundation

protocol VehicleInformationsProtocol {
    func verifyInformations(vehicle: VehicleInformations) -> VehicleCreationError?
}

class VehicleInformationsVerificator: VehicleInformationsProtocol {
    func verifyInformations(vehicle: VehicleInformations) -> VehicleCreationError? {
        switch true {
            case vehicle.license.isEmpty
                || vehicle.brand.isEmpty
                || vehicle.model.isEmpty: return .emptyField
            case vehicle.license.count != 9: return .incorrectLicense
            case vehicle.year.count != 4: return .incorrectYear
            default: return nil
        }
    }
}

struct VehicleInformations: Equatable, Encodable {
    var license: String
    var brand: String
    var type: String
    var year: String
    var model: String
}

enum VehicleCreationError: Equatable {
    case emptyField
    case incorrectYear
    case incorrectLicense

    var errorDescription: String {
        switch self {
            case .emptyField: return L10n.CreateVehicle.Error.emptyField
            case .incorrectYear: return L10n.CreateVehicle.Error.incorrectYear
            case .incorrectLicense: return L10n.CreateVehicle.Error.incorrectLicense
        }
    }
}
