//
//  URL+Extensions.swift
//  easyselling
//
//  Created by Maxence on 07/01/2022.
//

import Foundation
import UniformTypeIdentifiers

extension URL {
    var mimeType: UTType? {
        UTType(filenameExtension: pathExtension)
    }
}
