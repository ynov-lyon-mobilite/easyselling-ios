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
            case vehicle.licenceNumber.count != 14: return .wrongLicenceNumber
            case vehicle.immatriculation.count != 8: return .wrongImmatriculation
            case vehicle.year > 100: return .wrongYear
            case vehicle.licenceNumber.isEmpty
                || vehicle.immatriculation.isEmpty
                || vehicle.licenceNumber.isEmpty
                || vehicle.brand.isEmpty
                || vehicle.model.isEmpty: return .emptyField
            default: return nil
        }
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

enum VehicleCreationError: Equatable {
    case emptyField
    case wrongYear
    case wrongImmatriculation
    case wrongLicenceNumber
    case unknow
    
    var errorDescription: String? {
        switch self {
            case .emptyField: return "Un des champs est vide"
            case .wrongYear: return "L'année renseignée est invalide"
            case .wrongImmatriculation: return "L'immatriculation renseignée est invalide"
            case .wrongLicenceNumber: return "Le numéro de série est invalide"
            case .unknow: return "Une erreur est survenue lors de la création"
        }
    }
}
