//
//  VehicleInformationsVerificator.swift
//  easyselling
//
//  Created by Valentin Mont School on 17/10/2021.
//

import Foundation

protocol VehicleInformationsProtocol {
    func checkingInformations(vehicle: VehicleInformations) -> VehicleCreationError?
}

class VehicleInformationsVerificator: VehicleInformationsProtocol {
    func checkingInformations(vehicle: VehicleInformations) -> VehicleCreationError? {
        switch true {
        case vehicle.license.isEmpty
            || vehicle.license.isEmpty
            || vehicle.brand.isEmpty
            || vehicle.model.isEmpty: return .emptyField
            case vehicle.license.count != 9: return .wrongLicenseNumber
            case vehicle.year.count != 4: return .wrongYear
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
    case wrongYear
    case wrongLicenseNumber
    case unknow
    
    var errorDescription: String? {
        switch self {
            case .emptyField: return "Un des champs est vide"
            case .wrongYear: return "L'année renseignée est invalide"
            case .wrongLicenseNumber: return "Le numéro de série est invalide"
            case .unknow: return "Une erreur est survenue lors de la création"
        }
    }
}
