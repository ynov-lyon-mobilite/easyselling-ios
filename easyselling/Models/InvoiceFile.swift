//
//  File.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 05/12/2021.
//

import Foundation
import UIKit

struct InvoiceFile: Equatable, Codable {
    let filename: String
    let type: String
    let url: String
}

extension InvoiceFile {
    static var preview: InvoiceFile {
        .init(filename: "myFile.pdf", type: "application/pdf", url: "https://google.com")
    }
}

struct File: Equatable {
    var title: String
    var image: UIImage
}
