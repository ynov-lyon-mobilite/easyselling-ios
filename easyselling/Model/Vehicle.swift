//
//  Vehicule.swift
//  easyselling
//
//  Created by Théo Tanchoux on 13/10/2021.
//

import Foundation

struct Vehicle: Decodable {
    let id: String
    let owner: String
    let license: String
    let model: String
    let brand: String
    let type: String
    let category: String?
    let userAccess: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, owner, license, model, brand, type, category, userAccess = "user_access"
    }
}
