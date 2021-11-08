//
//  MyVehicleViewModel_Spec.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 25/10/2021.
//

import XCTest
@testable import easyselling

class MyVehiclesViewModel_Spec: XCTestCase {
    
    func test_Shows_vehicles_when_request_is_success() async {
        givenViewModel(apiCaller: SucceedingAPICaller())
        thenViewModelIsLoading()
        await whenTryingToGetVehicles()
        thenLoadVehicles(are: [Vehicle(id: "1", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1"),
                               Vehicle(id: "2", brand: "Renault", model: "model2", license: "license2", type: .car, year: "year2"),
                               Vehicle(id: "3", brand: "Citroen", model: "model3", license: "license3", type: .car, year: "year3")])
        thenViewModelIsNotLoading()
    }
    
    func test_Shows_error_when_request_is_failing() async {
        givenViewModel(apiCaller: FailingAPICaller(withError: 400))
        thenViewModelIsLoading()
        await whenTryingToGetVehicles()
        thenGetError()
        thenViewModelIsNotLoading()
    }
    
    private func givenViewModel(apiCaller: APICaller) {
        viewModel = MyVehiclesViewModel(requestGenerator: FakeRequestGenerator(),
                                        apiCaller: apiCaller,
                                        isOpenningVehicleCreation: {
                                                self.isOpen = true
                                            })
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
        XCTAssertEqual(.badRequest, viewModel.alert)
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
