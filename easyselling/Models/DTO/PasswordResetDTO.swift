//
//  PasswordResetDTO.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 12/11/2021.
//

import Foundation

struct PasswordResetDTO: Encodable, Equatable {
    var password: String
    var token: String
}
