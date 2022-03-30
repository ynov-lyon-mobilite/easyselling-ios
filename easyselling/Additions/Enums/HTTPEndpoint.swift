//
//  HTTPEndpoint.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 14/10/2021.
//

import Foundation

enum HTTPEndpoint: String {
    var baseURL: String { "https://api.easyselling.maxencemottard.com" }

    case users = "/users"
    case vehicles = "/vehicles"
    case vehicleId = "/vehicles/:vehicleId"
    case authLogin = "/auth/login"
    case files = "/files"
    case fileById = "/files/:fileId"
    case passwordResetRequest = "/auth/password/request"
    case passwordReset = "/auth/password/reset"
    case invoices = "/invoices/vehicle/:vehicleId"
    case invoiceId = "/invoices/:invoiceId"

    var url: URL? {
        URL(string: baseURL)?.appendingPathComponent(self.rawValue)
    }
}
