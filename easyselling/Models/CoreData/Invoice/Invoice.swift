//
//  Invoice.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 09/03/2022.
//

import Foundation
import CoreData

struct Invoice: Decodable, Equatable {
    var id : String
    var fileData: Data?
    var file: FileResponse?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case file
    }

    static func == (lhs: Invoice, rhs: Invoice) -> Bool {
        return true
    }

}

struct FileResponse: Decodable {
    var filename: String
}
