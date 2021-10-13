//
//  Vehicle.swift
//  easyselling
//
//  Created by Valentin Mont School on 13/10/2021.
//

enum VehicleType {
    case car
    case motorcycle
}

class Vehicle {
    var licenceNumber: String
    var brand: String
    var immatriculation: String
    var type: VehicleType
    var age: Int
    
    init(licenceNumber: String, brand: String, immatriculation: String, type: VehicleType, age: Int) {
        self.licenceNumber = licenceNumber
        self.brand = brand
        self.immatriculation = immatriculation
        self.type = type
        self.age = age
    }
}
