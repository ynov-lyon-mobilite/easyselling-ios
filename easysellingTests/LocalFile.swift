//
//  LocalFile.swift
//  easysellingTests
//
//  Created by Maxence on 10/11/2021.
//

import Foundation
import UIKit

enum LocalFile: String {
    case fileUploaderResponse = "FileUploaderResponse"
    case succeededVehicles = "succeededVehicles"
    case succeededInvoices = "succeededInvoices"
    case succeededFile = "succeededFile"
    case succeededImage = "succeededImage"
    case succeededVehicle = "succeededVehicle"
    case succeededVehicleModel = "succeededVehicleModel"
    case succeededVehicleBrand = "succeededVehicleBrand"
    
    var data: Data {
        //  If you have crash because path is nil. Don't forget to add the JSON file in both targets (easyselling & easysellingTests)
        let path = Bundle.main.path(forResource: rawValue, ofType: "json")!
        return try! String(contentsOfFile: path).data(using: .utf8)!
    }

    var image: Data {
        let path = Bundle.main.path(forResource: rawValue, ofType: "jpg")!
        return UIImage(contentsOfFile: path)?.jpegData(compressionQuality: 100) ?? Data()
    }
}
