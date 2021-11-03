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
        givenViewModel(urlSession: FakeUrlSession(with: expectedUrlResponse!))
        whenOpeningVehiculeCreationModal()
        thenVehicleCreationModalIsOpen()
    }
    
    func test_Shows_vehicle_when_request_is_success2() async {
        givenViewModel(urlSession: FakeUrlSession(with: expectedUrlResponse!))
        thenViewModelIsLoading()
        await whenTryingToGetVehicles()
        thenLoadVehicles(are: [Vehicle(brand: "Peugeot", model: "model1", license: "license1", type: "type1", year: "year1"),
                               Vehicle(brand: "Renault", model: "model2", license: "license2", type: "type2", year: "year2"),
                               Vehicle(brand: "Citroen", model: "model3", license: "license3", type: "type3", year: "year3")])
        thenViewModelIsNotLoading()
    }
    
    func test_Shows_error_when_request_is_failing() async {
        givenViewModel(urlSession: FakeUrlSession(error: .badRequest))
        thenViewModelIsLoading()
        await whenTryingToGetVehicles()
        thenGetError()
        thenViewModelIsNotLoading()
    }
    
    private func givenViewModel(urlSession: FakeUrlSession) {
        viewModel = MyVehiclesViewModel(isOpenningVehicleCreation: {
                                                self.isOpen = true
                                            },
                                            requestGenerator: FakeRequestGenerator("https://www.getvehicles.fr"),
                                            urlSession: urlSession)
    }
    
    private func whenTryingToGetVehicles() async {
        await viewModel.getVehicles()
    }
    
    private func whenOpeningVehiculeCreationModal() {
        viewModel.openVehicleCreation()
    }
    
    private func thenLoadVehicles(are expected: [Vehicle]) {
        XCTAssertEqual(expected, viewModel.vehicles)
    }
    
    private func thenGetError() {
        XCTAssertEqual(.badRequest, viewModel.error)
    }
    
    private func thenViewModelIsLoading() {
        XCTAssertTrue(viewModel.isLoading)
    }
    
    private func thenViewModelIsNotLoading() {
        XCTAssertFalse(viewModel.isLoading)
    }
    
    private func thenVehicleCreationModalIsOpen() {
        XCTAssertTrue(isOpen)
    }
 
    private var viewModel: MyVehiclesViewModel!
    private var isOpen: Bool!
    private var expectedUrlResponse: Data? = readLocalFile(forName: "succeededVehicles")
}

private func readLocalFile(forName name: String) -> Data? {
  guard let path = Bundle.main.path(forResource: name, ofType: "json"),
        let data = try? String(contentsOfFile: path).data(using: .utf8) else { return nil }

  return data
}
