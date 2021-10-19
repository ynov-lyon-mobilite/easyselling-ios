//
//  HTTPEndpoint.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 14/10/2021.
//

import Foundation

enum HTTPEndpoint: String {
    var baseURL: String { "https://easyselling.maxencemottard.com" }
    
    case users = "/users"
    case vehicles = "/items/vehicles"
    case authLogin = "/auth/login"
    
    var urlString: String {
        "\(baseURL)\(self.rawValue)"
    }
}
