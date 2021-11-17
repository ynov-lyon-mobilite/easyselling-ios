//
//  DefaultPasswordResetTransformator.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 17/11/2021.
//

import Foundation

class DefaultPasswordResetTransformator {
    
    func transformAsDTO(_ password: String) -> PasswordResetDTO {
        PasswordResetDTO(password: password, token: "")
    }
}
