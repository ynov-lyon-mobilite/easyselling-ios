//
//  Token.swift
//  easyselling
//
//  Created by Maxence on 20/10/2021.
//

import Foundation

struct Token: Decodable {
    let accessToken: String
    let refreshToken: String
    let expires: Int
    
    enum CodingKeys: String, CodingKey {
        case expires
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
