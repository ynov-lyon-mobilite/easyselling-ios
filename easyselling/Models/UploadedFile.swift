//
//  UploadedFile.swift
//  easyselling
//
//  Created by Maxence on 09/11/2021.
//

import Foundation

struct UploadedFile: Decodable, Equatable {
    let id: String
    let filename: String
    let type: String

    enum CodingKeys: String, CodingKey {
        case id = "_id", type, filename
    }
}
