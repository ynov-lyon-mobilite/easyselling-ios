//
//  HTTPError.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 14/10/2021.
//

import Foundation

enum HTTPError: Int, LocalizedError {
    case notFound = 404
    case unknow = 500
    
    var errorDescription: String? {
        switch self {
        case .notFound: return "Impossible de trouver ce que vous cherchez"
        case .unknow: return "Une erreur est survenue"
        }
    }
    
    static func from(statusCode: Int) -> Self {
        return Self.init(rawValue: statusCode) ?? HTTPError.unknow
    }
}
