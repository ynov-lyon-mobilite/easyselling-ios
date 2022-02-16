//
//  RefreshDTO.swift
//  easyselling
//
//  Created by Maxence on 02/11/2021.
//

import Foundation

struct RefreshDTO: Encodable {
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case refreshToken
    }
}
