//
//  VehicleScenario_Spec.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 25/10/2021.
//

import XCTest
@testable import easyselling

class VehicleScenario_Specs: XCTestCase {

    func test_Begins_scenario() {
        givenScenario()
        whenBeginning()
        thenHistory(is: [.myVehicles])
    }
    
    func test_Navigates_to_vehicle_update() {
        givenScenario()
        whenBeginning()
        whenNavigatingToVehicleUpdate(vehicle: Vehicle(id: "1", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1"))
        thenHistory(is: [.myVehicles, .vehicleUpdate])
    }
    
    func test_Leaves_vehicle_update() async {
        givenScenario()
        whenBeginning()
        whenNavigatingToVehicleUpdate(vehicle: vehicle)
        await whenLeavingVehicleUpdate()
        thenHistory(is: [.myVehicles, .vehicleUpdate, .myVehicles])
    }

    func test_Refreshes_vehicles_on_update_Modal() async {
        givenScenario()
        whenBeginning()
        whenNavigatingToVehicleUpdate(vehicle: vehicle)
        await whenLeavingVehicleUpdate()
        XCTAssertTrue(isRefresh)
    }
    func test_Navigates_to_vehicule_invoices() {
        givenScenario()
        whenBeginning()
        whenNavigatingToVehicleInvoices()
        thenVehicleId(is: vehicle)
        thenHistory(is: [.myVehicles, .vehicleInvoices])
    }

    private func givenScenario() {
        navigator = SpyVehicleCreationNavigator()
        scenario = VehicleScenario(navigator: navigator)
    }

    private func whenBeginning() {
        scenario.begin()
    }

    private func whenleavingVehicleCreation() async {
        await navigator.onFinish?()
	}

    private func whenLeavingVehicleUpdate() async {
        await navigator.onFinish?()
    }

    private func whenNavigatingToVehicleUpdate(vehicle: Vehicle) {
        scenario.navigatesToVehicleUpdate(vehicle: vehicle, refreshVehicles: {
            self.isRefresh = true
        })
    }

    private func whenNavigatingToVehicleInvoices() {
        navigator.onNavigatingToInvoices?(vehicle)
    }

    private func thenHistory(is expected: [SpyVehicleCreationNavigator.History]) {
        XCTAssertEqual(expected, navigator.history)
    }

    private func thenVehicleId(is expected: Vehicle) {
        XCTAssertEqual(expected, navigator.vehicle)
    }

    private var scenario: VehicleScenario!
    private var navigator: SpyVehicleCreationNavigator!
    private var isVehicleCreationFinished: Bool = false
    private var isRefresh: Bool = false
    private let vehicle = Vehicle(id: "1", brand: "Brand", model: "Model", license: "Licence", type: .car, year: "year")
}

class SpyVehicleCreationNavigator: VehicleNavigator {

    private(set) var history: [History] = []
    private(set) var onFinish: (() async -> Void)?
    private(set) var onNavigatingToInvoices: ((Vehicle) -> Void)?
    private(set) var onNavigateToSettingsMenu: Action?
    private(set) var vehicle = Vehicle(id: "1", brand: "Brand", model: "Model", license: "Licence", type: .car, year: "year")
    private(set) var vehicleScenarioIsFinished: Bool = false

    func navigatesToHomeView(onVehicleUpdateOpen: @escaping OnUpdatingVehicle, onNavigatingToInvoices: @escaping (Vehicle) -> Void) {
        self.onNavigatingToInvoices = onNavigatingToInvoices
        history.append(.myVehicles)
    }

    func navigatesToProfile() {
        history.append(.profile)
    }

    func navigatesToVehicleUpdate(onFinish: @escaping () async -> Void, vehicle: Vehicle) {
        self.onFinish = onFinish
        history.append(.vehicleUpdate)
    }

    func navigatesToInvoices(vehicle: Vehicle) {
        self.vehicle = vehicle
        history.append(.vehicleInvoices)
    }

    func goingBackToHomeView() {
        history.append(.myVehicles)
    }

    enum History: CustomDebugStringConvertible, Equatable {
        case myVehicles
        case profile
        case vehicleUpdate
        case vehicleInvoices

        var debugDescription: String {
            switch self {
            case .myVehicles: return "My vehicles"
            case .profile: return "profile"
            case .vehicleUpdate: return "vehicle update"
            case .vehicleInvoices: return "vehicle invoices"
            }
        }
    }
}
