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

    func test_Deletes_vehicle_when_request_is_success() async {
        givenViewModelDeletor(vehiclesGetter: SucceedingVehiclesGetter([Vehicle(id: "1", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1")]),
                              vehicleDeletor: SucceedingVehicleDeletor())
        whenVehicles(are: [Vehicle(id: "1", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1"),
                           Vehicle(id: "2", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1")])
        await whenDeletingVehicle(withId: "2")
        thenLoadVehicles(are: [Vehicle(id: "1", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1")])
    }

    func test_Deletes_vehicle_when_request_is_failing() async {
        givenViewModelDeletor(vehiclesGetter: SucceedingVehiclesGetter([Vehicle(id: "1", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1")]),
                              vehicleDeletor: FailingVehicleDeletor(withError: APICallerError.notFound))
        whenVehicles(are: [Vehicle(id: "1", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1"),
                           Vehicle(id: "2", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1")])
        await whenDeletingVehicle(withId: "2")
        thenError(is: "Impossible de trouver ce que vous cherchez")
    }

    private func whenNavigatingToProfile() {
        viewModel.navigateToProfile()
    }

    private func thenHasNavigatingToProfile() {
        XCTAssertTrue(onNavigateToProfile)
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
        viewModel = MyVehiclesViewModel(vehiclesGetter: vehiclesGetter, vehicleDeletor: vehicleDeletor, isOpenningVehicleCreation: { self.isOpen = true }, isNavigatingToProfile: { self.onNavigateToProfile = true })
    }
    
    private func whenTryingToGetVehicles() async {
        await viewModel.getVehicles()
    }
    
    private func whenDeletingVehicle(withId: String) async {
        await viewModel.deleteVehicle(idVehicle: withId)
    }
    
    private func whenOpeningVehiculeCreationModal() {
        viewModel.openVehicleCreation()
    }

    private func whenVehicles(are vehicles: [Vehicle]) {
        viewModel.vehicles = vehicles
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
 
    private var viewModel: MyVehiclesViewModel!
    private var isOpen: Bool!
    private var expectedUrlResponse: Data? = readLocalFile(forName: "succeededVehicles")
    private var onNavigateToProfile: Bool = false
}

private func readLocalFile(forName name: String) -> Data? {
  guard let path = Bundle.main.path(forResource: name, ofType: "json"),
        let data = try? String(contentsOfFile: path).data(using: .utf8) else { return nil }

  return data
}
