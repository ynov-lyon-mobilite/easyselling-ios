//
//  DefaultVehicleVerificator.swift
//  easyselling
//
//  Created by Valentin Mont School on 27/11/2021.
//

import Foundation

protocol VehicleVerificator {
    func verifylicenceSize(licence: String) throws
    func verifylicenceFormat(licence: String) throws
}

class DefaultVehicleVerificator: VehicleVerificator {

    func verifylicenceSize(licence: String) throws {
        let oldlicence = try? NSRegularExpression(pattern: "^.{3} .{3} .{2}$")
        let newlicence = try? NSRegularExpression(pattern: "^.{2}-.{3}-.{2}$")
        let range = NSRange(location: 0, length: licence.count)
        let licenceIsCorrect = (newlicence?.firstMatch(in: licence, options: [], range: range) != nil) ||
                     (oldlicence?.firstMatch(in: licence, options: [], range: range) != nil)

        guard licenceIsCorrect else {
            throw VehicleCreationError.incorrectlicenceSize
        }
    }

    func verifylicenceFormat(licence: String) throws {
        let oldlicence = try? NSRegularExpression(pattern: "^[0-9]* [A-Z]* [0-9]*$")
        let newlicence = try? NSRegularExpression(pattern: "^[A-Z]*-[0-9]*-[A-Z]*$")
        let range = NSRange(location: 0, length: licence.count)
        let licenceIsCorrect = (newlicence?.firstMatch(in: licence, options: [], range: range) != nil) ||
                     (oldlicence?.firstMatch(in: licence, options: [], range: range) != nil)

        guard licenceIsCorrect else {
            throw VehicleCreationError.incorrectlicenceFormat
        }
    }
}
