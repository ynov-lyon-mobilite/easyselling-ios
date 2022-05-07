//
//  Brand.swift
//  easyselling
//
//  Created by Lucas Barthélémy on 20/04/2022.
//

import Foundation

struct Brand: Decodable, Equatable, Hashable {
    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id", name
    }
}
