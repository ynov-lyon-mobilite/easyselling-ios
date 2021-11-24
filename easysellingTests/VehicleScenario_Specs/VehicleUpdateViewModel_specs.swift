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
        updateInformations(Vehicle(brand: "Peugeot", model: "model1", license: "license2", type: .car, year: "2021"))
        updateVehicle()
    }
    
    private func givenViewModel() {
        viewModel = VehicleUpdateViewModel(vehicle: Vehicle(id: "1", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1"), onFinish: {}, vehicleVerificator: DefaultVehicleInformationsVerificator())
    }
    
    private func updateInformations(_ newInformations: Vehicle) {
        viewModel.brand = newInformations.brand
        viewModel.model = newInformations.model
        viewModel.license = newInformations.license
        viewModel.type = newInformations.type
        viewModel.year = newInformations.year
    }

    private func updateVehicle() {
        viewModel.updateVehicle()
    }
}
