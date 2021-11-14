//
//  FileDTO.swift
//  easyselling
//
//  Created by Maxence on 07/01/2022.
//

import Foundation
import UniformTypeIdentifiers

struct FileDTO {
    let name: String
    let type: String
    let data: Data

    init?(name: String, type: UTType, data: Data) {
        guard let mimeType = type.preferredMIMEType else { return nil }

        self.name = name
        self.type = mimeType
        self.data = data
    }

    init(name: String, type: String, data: Data) {
        self.name = name
        self.type = type
        self.data = data
    }
}
