//
//  Token.swift
//  easyselling
//
//  Created by Maxence on 15/10/2021.
//

import Foundation

struct TokenResponse: Decodable, Equatable {
    let accessToken: String
    let expires: Int
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expires
        case refreshToken = "refresh_token"
    }
}
