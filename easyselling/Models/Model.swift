//
//  Model.swift
//  easyselling
//
//  Created by Lucas Barthélémy on 20/04/2022.
//

import Foundation

struct Model: Decodable, Equatable, Hashable {
    let id: String
    let brand: String
    let model: String
    let type: Vehicle.Category

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case brand, model, type
    }
}
