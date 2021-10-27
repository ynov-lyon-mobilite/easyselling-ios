//
//  MyVehicleViewModel_Spec.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 25/10/2021.
//

import XCTest
@testable import easyselling

class MyVehiclesViewModel_Spec: XCTestCase {
    
    func test_Opens_vehicle_creation_modal() {
        let viewModel = MyVehiclesViewModel(isOpenningVehicleCreation: {
            self.isOpen = true
        })
        viewModel.openVehicleCreation()
        XCTAssertTrue(isOpen)
    }
    
    private var isOpen: Bool!
}
