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
    
    func test_Shows_vehicle_when_request_is_success2() async {
        let viewModel = MyVehiclesViewModel(isOpenningVehicleCreation: {},
                                            requestGenerator: FakeRequestGenerator("https://www.getvehicles.fr"),
                                            urlSession: FakeUrlSession(with: expectedUrlResponse!))
        XCTAssertTrue(viewModel.loading)
        await viewModel.getVehicles()
        XCTAssertEqual([Vehicle(brand: "Peugeot"),
                        Vehicle(brand: "Renault"),
                        Vehicle(brand: "Citroen")], viewModel.vehicles)
        XCTAssertFalse(viewModel.loading)
    }

    
    private var isOpen: Bool!
    private var expectedUrlResponse: Data? = readLocalFile(forName: "succeededVehicles")
}

private func readLocalFile(forName name: String) -> Data? {
  guard let path = Bundle.main.path(forResource: name, ofType: "json"),
        let data = try? String(contentsOfFile: path).data(using: .utf8) else { return nil }

  return data
}
