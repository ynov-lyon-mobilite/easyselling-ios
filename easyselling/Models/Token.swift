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
}
