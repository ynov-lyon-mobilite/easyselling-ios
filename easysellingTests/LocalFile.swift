//
//  LocalFile.swift
//  easysellingTests
//
//  Created by Maxence on 10/11/2021.
//

import Foundation

enum LocalFile: String {
    case fileUploaderResponse = "FileUploaderResponse"
    case userAuthenticatorResponse = "UserAuthenticatorResponse"
    case succeededVehicles = "succeededVehicles"
    
    var data: Data {
        //  If you have crash because path is nil. Don't forget to add the JSON file in both targets (easyselling & easysellingTests)
        let path = Bundle.main.path(forResource: rawValue, ofType: "json")!
        return try! String(contentsOfFile: path).data(using: .utf8)!
    }
}
