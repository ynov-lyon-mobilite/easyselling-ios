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
    var label: String
    var mileage: Int
    var date: Date
    var vehicle: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case file
        case label
        case mileage
        case date
        case vehicle
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(String.self, forKey: .id)
        self.file = try values.decodeIfPresent(FileResponse.self, forKey: .file)
        self.label = try values.decode(String.self, forKey: .label)
        self.mileage = try values.decode(Int.self, forKey: .mileage)
        self.vehicle = try values.decode(String.self, forKey: .vehicle)
        let stringDate = try values.decode(String.self, forKey: .date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS'Z'"
        guard let date = dateFormatter.date(from: stringDate) else {
            throw APICallerError.decodeError
        }
        self.date = date
    }

    internal init(id: String, file: FileResponse? = nil, label: String, mileage: Int, date: Date, vehicle: String) {
        self.id = id
        self.file = file
        self.label = label
        self.mileage = mileage
        self.date = date
        self.vehicle = vehicle
    }

    func toCoreDataObject (in context: NSManagedObjectContext) -> InvoiceCoreData {
        return InvoiceCoreData(id: self.id, fileTitle: self.file?.filename, fileData: self.fileData ?? Data(), fileLabel: self.label, fileMileage: self.mileage, fileDate: self.date, fileVehicle: self.vehicle, in: context)
    }
}

struct FileResponse: Decodable, Equatable {
    var filename: String
}
