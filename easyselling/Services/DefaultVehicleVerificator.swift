//
//  DefaultVehicleVerificator.swift
//  easyselling
//
//  Created by Valentin Mont School on 27/11/2021.
//

import Foundation

protocol VehicleVerificator {
    func verifyLicenseSize(license: String) -> Bool
    func verifyLicenseFormat(license: String) -> Bool
}

class DefaultVehicleVerificator: VehicleVerificator {

    func verifyLicenseSize(license: String) -> Bool {
        let isNewLicense = !license[String.Index(utf16Offset: 0, in: license)].isNumber

        switch true {
        case license.count != 9 && license.count != 10:
            return true
        case license.count != 9 && isNewLicense:
            return true
        case license.count != 10 && !isNewLicense:
            return true
        default: return false
        }
    }

    func verifyLicenseFormat(license: String) -> Bool {
        let oldLicense = try? NSRegularExpression(pattern: "^[0-9]* [A-Z]* [0-9]*$")
        let newLicense = try? NSRegularExpression(pattern: "^[A-Z]*-[0-9]*-[A-Z]*$")
        let range = NSRange(location: 0, length: license.count)
        let result = (newLicense?.firstMatch(in: license, options: [], range: range) != nil) ||
                     (oldLicense?.firstMatch(in: license, options: [], range: range) != nil)

        return !result
    }
}
