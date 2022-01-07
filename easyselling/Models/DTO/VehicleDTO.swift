//
//  Vehicle.swift
//  easyselling
//
//  Created by Théo Tanchoux on 07/11/2021.
//

import Foundation

struct Vehicle: Codable, Equatable, Identifiable {
    var id: String?
    var brand: String
    var model: String
    var license: String
    var type: String
    var year: String
}
