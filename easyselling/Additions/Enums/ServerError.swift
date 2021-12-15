//
//  ServerError.swift
//  easyselling
//
//  Created by Valentin Mont School on 15/12/2021.
//

import Foundation

enum ServerError: String, LocalizedError, Equatable {
    case forbidden = "FORBIDDEN"
    case service_unavailable = "SERVICE_UNAVAILABLE"

    var errorDescription: String? {
        switch self {
            case .forbidden: return L10n.ServerError.forbidden
            case .service_unavailable: return L10n.ServerError.serviceUnavailable
        }
    }
}
