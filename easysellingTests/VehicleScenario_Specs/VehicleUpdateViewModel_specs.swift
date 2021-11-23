//
//  VehicleUpdateViewModel_specs.swift
//  easysellingTests
//
//  Created by Pierre Gourgouillon on 21/11/2021.
//

import XCTest
@testable import easyselling

class VehicleUpdateViewModel_specs: XCTestCase {
    
    private var viewModel: VehicleUpdateViewModel!
    
    func test_modifies_the_existing_vehicle() {
        givenViewModel()
        modifyBrand("Renault")
        verifyModification()
    }
    
    private func givenViewModel() {
        viewModel = VehicleUpdateViewModel(vehicle: Vehicle(id: "1", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1"), onFinish: {}, vehicleVerificator: DefaultVehicleInformationsVerificator())
    }
    
    private func modifyBrand(_ value: String) {
        viewModel.brand = value
    }
    
    private func verifyModification() {
        viewModel.verifyVehiculeModification()
    }
}
