//
//  VehicleCreationViewModel_Spec.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 25/10/2021.
//

import XCTest
@testable import easyselling

class VehicleCreationViewModel_Spec: XCTestCase {
    
    func test_Leaves_vehicle_creation_on_vehicle_informations_submit() {
        let viewModel = VehicleCreationViewModel(onFinish: {
            self.isCreated = true
        })
        viewModel.createVehicle()
        XCTAssertTrue(isCreated)
    }
    
    private var isCreated: Bool!
}
