//
//  MyVehicleViewModel_Spec.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 25/10/2021.
//

import XCTest
@testable import easyselling

class MyVehiclesViewModel_Specs: XCTestCase {
    
    func test_Shows_vehicles_when_request_is_success() async {
        let expectedVehicles = [Vehicle(id: "1", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1"),
                                Vehicle(id: "2", brand: "Renault", model: "model2", license: "license2", type: .car, year: "year2")]
        givenViewModel(vehiclesGetter: SucceedingVehiclesGetter(expectedVehicles))
        thenViewModelState(is: .loading)
        await whenTryingToGetVehicles()
        thenLoadVehicles(are: [Vehicle(id: "1", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1"),
                               Vehicle(id: "2", brand: "Renault", model: "model2", license: "license2", type: .car, year: "year2")])
        thenViewModelState(is: .listingVehicles)
    }
    
    func test_Shows_error_when_request_is_failing() async {
        givenViewModel(vehiclesGetter: FailingVehiclesGetter(withError: APICallerError.notFound))
        thenViewModelState(is: .loading)
        await whenTryingToGetVehicles()
        thenViewModelState(is: .error)
        thenError(is: "Impossible de trouver ce que vous cherchez")
    }

    func test_Navigates_to_profile_view_when_clicking_on_profile_button() {
        givenViewModel(vehiclesGetter: SucceedingVehiclesGetter([]))
        whenNavigatingToProfile()
        thenHasNavigatingToProfile()
    }

    private func whenNavigatingToProfile() {
        viewModel.navigateToProfile()
    }

    private func thenHasNavigatingToProfile() {
        XCTAssertTrue(onNavigateToProfile)
    }
    
    func test_Deletes_vehicle_when_request_is_success() async {
        givenListOfVehicle(is: [Vehicle(id: "1", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1"),
                            Vehicle(id: "2", brand: "Renault", model: "model2", license: "license2", type: .car, year: "year2")])
        givenViewModelDeletor(vehiclesGetter: SucceedingVehiclesGetter(listOfVehicle), vehicleDeletor: SucceedingVehicleDeletor(listOfVehicle))
        await whenDeletingVehicle(withId: "2")
        thenListOfVehicleAfterDelete(is: [Vehicle(id: "1", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1")])
    }
    
    private func givenViewModel(vehiclesGetter: VehiclesGetter) {
        viewModel = MyVehiclesViewModel(vehiclesGetter: vehiclesGetter,
                                        isOpenningVehicleCreation: {
                                                self.isOpen = true
        }, isNavigatingToProfile: {
            self.onNavigateToProfile = true
        })
    }
    
    private func givenViewModelDeletor(vehiclesGetter: VehiclesGetter, vehicleDeletor: VehicleDeletor) {
        viewModel = MyVehiclesViewModel(vehiclesGetter: vehiclesGetter, vehicleDeletor: vehicleDeletor, isOpenningVehicleCreation: {self.isOpen = true})
    }
    
    private func givenListOfVehicle(is list: [Vehicle]) {
        self.listOfVehicle = list
    }
    
    private func whenTryingToGetVehicles() async {
        await viewModel.getVehicles()
    }
    
    private func whenDeletingVehicle(withId: String) async {
        await viewModel.deleteVehicle(id: id)
        self.listOfVehicle = viewModel.vehicleDeletor.vehicles
    }
    
    private func whenOpeningVehiculeCreationModal() {
        viewModel.openVehicleCreation()
    }
    
    private func thenLoadVehicles(are expected: [Vehicle]) {
        XCTAssertEqual(expected, viewModel.vehicles)
    }
    
    private func thenError(is expected: String) {
        XCTAssertEqual(expected, viewModel.error?.errorDescription)
    }
    
    private func thenViewModelState(is expected: MyVehiclesViewModel.VehicleState) {
        XCTAssertEqual(expected, viewModel.state)
    }
    
    private func thenVehicleCreationModalIsOpen() {
        XCTAssertTrue(isOpen)
    }
    
    private func thenListOfVehicleAfterDelete(is expected: [Vehicle]) {
        XCTAssertEqual(expected, self.listOfVehicle)
    }
 
    private var viewModel: MyVehiclesViewModel!
    private var isOpen: Bool!
    private var expectedUrlResponse: Data? = readLocalFile(forName: "succeededVehicles")
    private var onNavigateToProfile: Bool = false
    private var listOfVehicle: [Vehicle]!
}

private func readLocalFile(forName name: String) -> Data? {
  guard let path = Bundle.main.path(forResource: name, ofType: "json"),
        let data = try? String(contentsOfFile: path).data(using: .utf8) else { return nil }

  return data
}
