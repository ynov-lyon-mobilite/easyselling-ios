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
    case vehicleId = "/items/vehicles/:vehicleId"
    case authLogin = "/auth/login"
    case authRefresh = "/auth/refresh"
    case files = "/files"
    case fileById = "/files/:fileId"
    case downloadFile = "/assets/:fileId"
    case passwordResetRequest = "/auth/password/request"
    case passwordReset = "/auth/password/reset"
    case invoices = "/items/invoices"

    var url: URL? {
        URL(string: baseURL)?.appendingPathComponent(self.rawValue)
    }
}
