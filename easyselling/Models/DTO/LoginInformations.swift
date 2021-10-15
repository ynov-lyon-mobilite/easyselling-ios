//
//  LoginInformations.swift
//  easyselling
//
//  Created by Maxence on 15/10/2021.
//

import Foundation

struct LoginInformations: Encodable {
    let email: String
    let password: String
    let otp: String?
}
