//
//  DefaultVehicleVerificator.swift
//  easyselling
//
//  Created by Valentin Mont School on 27/11/2021.
//

import Foundation

protocol VehicleVerificator {
    func verifyLicenseSize(license: String) throws
    func verifyLicenseFormat(license: String) throws
}

class DefaultVehicleVerificator: VehicleVerificator {

    func verifyLicenseSize(license: String) throws {
        let oldLicense = try? NSRegularExpression(pattern: "^.{3} .{3} .{2}$")
        let newLicense = try? NSRegularExpression(pattern: "^.{2}-.{3}-.{2}$")
        let range = NSRange(location: 0, length: license.count)
        let licenseIsCorrect = (newLicense?.firstMatch(in: license, options: [], range: range) != nil) ||
                     (oldLicense?.firstMatch(in: license, options: [], range: range) != nil)

        guard licenseIsCorrect else {
            throw VehicleCreationError.incorrectLicenseSize
        }
    }

    func verifyLicenseFormat(license: String) throws {
        let oldLicense = try? NSRegularExpression(pattern: "^[0-9]* [A-Z]* [0-9]*$")
        let newLicense = try? NSRegularExpression(pattern: "^[A-Z]*-[0-9]*-[A-Z]*$")
        let range = NSRange(location: 0, length: license.count)
        let licenseIsCorrect = (newLicense?.firstMatch(in: license, options: [], range: range) != nil) ||
                     (oldLicense?.firstMatch(in: license, options: [], range: range) != nil)

        guard licenseIsCorrect else {
            throw VehicleCreationError.incorrectLicenseFormat
        }
    }
}
