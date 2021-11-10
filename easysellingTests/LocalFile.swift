//
//  LocalFile.swift
//  easysellingTests
//
//  Created by Maxence on 10/11/2021.
//

import Foundation

enum LocalFile: String {
    case fileUploaderResponse = "FileUploaderResponse"
    
    var data: Data? {
        guard let path = Bundle.main.path(forResource: rawValue, ofType: "json"),
              let data = try? String(contentsOfFile: path).data(using: .utf8) else { return nil }
        
        return data
    }
}
