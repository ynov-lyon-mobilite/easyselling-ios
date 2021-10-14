//
//  HTTPError.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 14/10/2021.
//

import Foundation

enum HTTPError: Int, LocalizedError {
    case badRequest = 400
    case unauthorized = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406
    case proxyAuthenticationRequired = 407
    case requestTimeout = 408
    case conflict = 409
    case gone = 410
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    
    var errorDescription: String? {
        switch self {
        case .notFound: return "Impossible de trouver ce que vous cherchez"
        case .internalServerError: return "Une erreur est survenue"
        default: return "Une erreur est survenue"
        }
    }
    
    static func from(statusCode: Int) -> Self {
        return Self.init(rawValue: statusCode) ?? HTTPError.internalServerError
    }
}
