//
//  Vehicule.swift
//  easyselling
//
//  Created by Théo Tanchoux on 13/10/2021.
//

import Foundation

struct Vehicle: Decodable, Identifiable {
    let id: String
    let owner: String
    let license: String
    let model: String
    let brand: String
    let type: CarType
    let category: CarCategory?
    let year: String
    let userAccess: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, owner, license, model, brand, type, category, year, userAccess = "user_access"
    }
}

enum CarType: String, Decodable {
    case car, moto
    
    var description: String {
        switch self {
        case .car:
            return "Voiture"
        case .moto:
            return "Moto"
        }
    }
}

enum CarCategory: String, Decodable {
    case mtt1, mtt2
}
