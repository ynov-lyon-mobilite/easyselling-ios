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

    func toCoreDataObject (in context: NSManagedObjectContext) -> InvoiceCoreData {
        return InvoiceCoreData(id: self.id, fileTitle: self.file?.filename, fileData: self.fileData ?? Data(), in: context)
    }
}

struct FileResponse: Decodable, Equatable {
    var filename: String
}
