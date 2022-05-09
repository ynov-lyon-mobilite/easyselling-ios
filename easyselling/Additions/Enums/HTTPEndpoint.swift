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
    case invoices = "/invoices/vehicle/:vehicleId"
    case invoiceId = "/invoices/:invoiceId"
    case vehicleBrands = "/vehicles/brands"
    case vehicleModels = "/vehicles/models"
    case shareVehicle = "/vehicles/:vehicleId/share"
    case sharedVehicles = "/vehicles/shared"
    case activateVehicle = "/vehicles/authorization/:authorizationId/active"

    var url: URL? {
        URL(string: baseURL)?.appendingPathComponent(self.rawValue)
    }
}
