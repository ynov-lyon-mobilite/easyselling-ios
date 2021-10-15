//
//  HTTPEndpoint.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 14/10/2021.
//

import Foundation

enum HTTPEndpoint: String {
    var baseURL: String { "https://easyselling.maxencemottard.com/api/v1" }
    
    case users = "/users"
    case usersLogin = "/users/login"
    
    var urlString: String {
        "\(baseURL)\(self.rawValue)"
    }
}
