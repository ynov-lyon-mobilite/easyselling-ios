//
//  MyVehicleViewModel_Spec.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 25/10/2021.
//

import XCTest
@testable import easyselling

class MyVehiclesViewModel_Specs: XCTestCase {

    func test_Navigates_to_vehicle_creation() {
        givenViewModel(vehiclesGetter: SucceedingVehiclesGetter([]))
        whenOpeningVehiculeCreationModal()
        thenHasNavigatingToVehicleCreationModal()
    }
    
    func test_Shows_vehicles_when_request_is_success() async {
        expectedVehicles = [Vehicle(id: "1", brand: "Peugeot", model: "model1", licence: "licence1", type: .car, year: "year1"),
                            Vehicle(id: "2", brand: "Renault", model: "model2", licence: "licence2", type: .car, year: "year2")]
        givenViewModel(vehiclesGetter: SucceedingVehiclesGetter(expectedVehicles))
        thenViewModelState(is: .loading)
        await whenTryingToGetVehicles()
        thenLoadVehicles(are: [Vehicle(id: "1", brand: "Peugeot", model: "model1", licence: "licence1", type: .car, year: "year1"),
                               Vehicle(id: "2", brand: "Renault", model: "model2", licence: "licence2", type: .car, year: "year2")])
        thenViewModelState(is: .listingVehicles)
    }

    func test_Shows_error_when_request_is_failing() async {
        givenViewModel(vehiclesGetter: FailingVehiclesGetter(withError: APICallerError.notFound))
        thenViewModelState(is: .loading)
        await whenTryingToGetVehicles()
        thenViewModelState(is: .error)
        thenError(is: APICallerError.notFound.errorDescription)
    }

    func test_Deletes_vehicle_when_request_is_success() async {
        givenViewModelDeletor(vehiclesGetter: SucceedingVehiclesGetter([
            Vehicle(id: "1", brand: "Peugeot", model: "model1", licence: "licence1", type: .car, year: "year1"),
            Vehicle(id: "2", brand: "Peugeot", model: "model1", licence: "licence1", type: .car, year: "year1")]),
                              vehicleDeletor: SucceedingVehicleDeletor())
        await whenTryingToGetVehicles()
        await whenDeletingVehicle(withId: "2")
        thenLoadVehicles(are: [Vehicle(id: "1", brand: "Peugeot", model: "model1", licence: "licence1", type: .car, year: "year1")])
    }

    func test_Deletes_vehicle_when_request_is_failing() async {
        givenViewModelDeletor(vehiclesGetter: SucceedingVehiclesGetter([
            Vehicle(id: "1", brand: "Peugeot", model: "model1", licence: "licence1", type: .car, year: "year1"),
            Vehicle(id: "2", brand: "Peugeot", model: "model1", licence: "licence1", type: .car, year: "year1")]),
                              vehicleDeletor: FailingVehicleDeletor(withError: APICallerError.notFound))
        await whenDeletingVehicle(withId: "2")
        thenError(is: APICallerError.notFound.errorDescription)
    }

    func test_Asserts_that_updated_vehicle_is_the_same_that_has_been_clicked() {
        expectedVehicles = [Vehicle(id: "1", brand: "Peugeot", model: "model1", licence: "licence1", type: .car, year: "year1"),
                            Vehicle(id: "2", brand: "Renault", model: "model2", licence: "licence2", type: .car, year: "year2")]
        givenViewModel(vehiclesGetter: SucceedingVehiclesGetter(expectedVehicles))
        whenOpeningVehicleUpdatingModal(vehicleId: "1")
        thenVehicleThatShouldBeUpdate(is: Vehicle(id: "1", brand: "Peugeot", model: "model1", licence: "licence1", type: .car, year: "year1"))
    }

    func test_Asserts_that_update_vehicles_callback_contain_on_other_callback_parameter() {
        expectedVehicles = [Vehicle(id: "1", brand: "Peugeot", model: "model1", licence: "licence1", type: .car, year: "year1"),
                            Vehicle(id: "2", brand: "Renault", model: "model2", licence: "licence2", type: .car, year: "year2")]
        givenViewModel(vehiclesGetter: SucceedingVehiclesGetter(expectedVehicles))
        whenOpeningVehicleUpdatingModal(vehicleId: "1")
        XCTAssertNotNil(expectedCallback)
    }
    
    func test_Navigates_to_vehicle_invoices_with_vehicle_id_as_parameter() {
        let vehicle = Vehicle(id: "1", brand: "Brand", model: "Model", licence: "Licence", type: .car, year: "year")
        givenViewModel(vehiclesGetter: SucceedingVehiclesGetter([vehicle]))
        whenNavigatingToInvoicesView(vehicle: vehicle)
        thenVehicleId(is: vehicle)
        thenNavigatesToInvoices()
    }
    
    func test_Navigates_to_vehicle_invoices() {
        let vehicle = Vehicle(id: "1", brand: "Brand", model: "Model", licence: "Licence", type: .car, year: "year")
        givenViewModel(vehiclesGetter: SucceedingVehiclesGetter([vehicle]))
        viewModel.navigatesToInvoices(vehicle: vehicle)
        XCTAssertTrue(onNavigatingToInvoices)
    }
    
    private func givenViewModel(vehiclesGetter: VehiclesGetter) {
        viewModel = MyVehiclesViewModel(vehiclesGetter: vehiclesGetter,
                                        isOpeningVehicleUpdate: { vehicle, onRefreshCallback in
            self.onUpdateVehicle = vehicle
            self.expectedCallback = onRefreshCallback
        }, isNavigatingToInvoices: { vehicleId in
        	self.selectedVehicle = vehicleId
			self.onNavigatingToInvoices = true
		}, isOpeningVehicleShare: { vehicleId in
            self.selectedVehicleId = vehicleId
        })
    }

    private func givenViewModelDeletor(vehiclesGetter: VehiclesGetter, vehicleDeletor: VehicleDeletor) {
        viewModel = MyVehiclesViewModel(vehiclesGetter: vehiclesGetter, vehicleDeletor: vehicleDeletor, isOpeningVehicleUpdate: { _,_ in }, isNavigatingToInvoices: {_ in}, isOpeningVehicleShare: {_ in })
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

    private func whenNavigatingToInvoicesView(vehicle: Vehicle) {
        viewModel.navigatesToInvoices(vehicle: vehicle)
    }

    private func whenVehicles(are vehicles: [Vehicle]) {
        viewModel.vehicles = vehicles
	}

    private func whenOpeningVehicleUpdatingModal(vehicleId: String) {
        viewModel.openVehicleUpdate(vehicle: expectedVehicles.first { $0.id == vehicleId }!)
    }
    
    private func thenLoadVehicles(are expected: [Vehicle]) {
        XCTAssertEqual(expected, viewModel.vehicles)
    }
    
    private func thenError(is expected: String?) {
        XCTAssertEqual(expected, viewModel.error?.errorDescription)
    }
    
    private func thenViewModelState(is expected: MyVehiclesViewModel.VehicleState) {
        XCTAssertEqual(expected, viewModel.state)
    }

    private func thenVehicleThatShouldBeUpdate(is expected: Vehicle) {
        XCTAssertEqual(expected, onUpdateVehicle)
    }
    
    private func thenVehicleId(is expected: Vehicle) {
        XCTAssertEqual(expected, selectedVehicle)
    }

    private func thenNavigatesToInvoices() {
        XCTAssertTrue(onNavigatingToInvoices)
    }

    private func thenNavigatesToSettingsMenu() {
        XCTAssertTrue(onNavigateToSettingsMenu)
    }

    private func thenHasNavigatingToVehicleCreationModal() {
        XCTAssertTrue(viewModel.isOpenningVehicleCreation)
    }
 
    private var viewModel: MyVehiclesViewModel!
    private var expectedUrlResponse: Data? = readLocalFile(forName: "succeededVehicles")
    private var onNavigateToProfile: Bool = false
    private var expectedVehicles: [Vehicle] = []
    private var onUpdateVehicle: Vehicle!
    private var expectedCallback: AsyncableAction!
    private var onNavigatingToInvoices: Bool = false
    private var selectedVehicle: Vehicle!
    private var onNavigateToSettingsMenu: Bool = false
}

private func readLocalFile(forName name: String) -> Data? {
  guard let path = Bundle.main.path(forResource: name, ofType: "json"),
        let data = try? String(contentsOfFile: path).data(using: .utf8) else { return nil }

  return data
}
