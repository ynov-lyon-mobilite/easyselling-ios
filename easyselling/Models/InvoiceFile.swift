//
//  File.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 05/12/2021.
//

import Foundation
import UIKit

struct InvoiceFile: Equatable, Decodable {

    var title: String
    var type: String
}

struct File: Equatable {

    var title: String
    var image: UIImage
}
