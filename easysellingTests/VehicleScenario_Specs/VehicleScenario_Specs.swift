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
    
    func test_Navigates_to_vehicle_creation() {
        givenScenario()
        whenBeginning()
        whenNavigatingToVehicleCreation()
        thenHistory(is: [.myVehicles, .vehicleCreation])
    }
    
    func test_Navigates_to_vehicle_update() {
        givenScenario()
        whenBeginning()
        whenNavigatingToVehicleUpdate(vehicle: Vehicle(id: "1", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1"))
        thenHistory(is: [.myVehicles, .vehicleUpdate])
    }

    func test_Leaves_vehicle_creation() async {
        givenScenario()
        whenBeginning()
        whenNavigatingToVehicleCreation()
        await whenleavingVehicleCreation()
        thenHistory(is: [.myVehicles, .vehicleCreation, .myVehicles])
    }

    func test_Navigates_to_profil_scenario() {
        givenScenario()
        whenBeginning()
        whenNavigatingToProfil()
        thenHistory(is: [.myVehicles, .profile])
    }

    private func whenNavigatingToProfil() {
        navigator.onNavigateToProfile?()
    }
    
    func test_Leaves_vehicle_update() async {
        givenScenario()
        whenBeginning()
        whenNavigatingToVehicleUpdate(vehicle: Vehicle(id: "1", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1"))
        await whenLeavingVehicleUpdate()
        thenHistory(is: [.myVehicles, .vehicleUpdate, .myVehicles])
    }

    func test_Refreshes_vehicles_on_update_Modal() async {
        givenScenario()
        whenBeginning()
        whenNavigatingToVehicleUpdate(vehicle: Vehicle(id: "1", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1"))
        await whenLeavingVehicleUpdate()
        XCTAssertTrue(isRefresh)
    }
    
    private func givenScenario() {
        navigator = SpyVehicleCreationNavigator()
        scenario = VehicleScenario(navigator: navigator)
    }
    
    private func whenBeginning() {
        scenario.begin()
    }
    
    private func whenNavigatingToVehicleCreation() {
        navigator.onNavigateToVehicleCreation?()
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
 
    private func thenHistory(is expected: [SpyVehicleCreationNavigator.History]) {
        XCTAssertEqual(expected, navigator.history)
    }
    
    private var scenario: VehicleScenario!
    private var navigator: SpyVehicleCreationNavigator!
    private var isVehicleCreationFinished: Bool = false
    private var isRefresh: Bool = false
}

class SpyVehicleCreationNavigator: VehicleNavigator {

    private(set) var history: [History] = []
    private(set) var onFinish: (() async -> Void)?
    private(set) var onNavigateToVehicleCreation: Action?
    private(set) var onNavigateToProfile: Action?
    
    func navigatesToHomeView(onVehicleCreationOpen: @escaping Action, onVehicleUpdateOpen: @escaping OnUpdatingVehicle, onNavigateToProfile: @escaping Action) {
        self.onNavigateToVehicleCreation = onVehicleCreationOpen
        self.onNavigateToProfile = onNavigateToProfile
        history.append(.myVehicles)
    }
    
    func navigatesToVehicleCreation(onFinish: @escaping () async -> Void) {
        self.onFinish = onFinish
        history.append(.vehicleCreation)
    }

    func navigatesToProfile() {
        history.append(.profile)
    }
    
    func navigatesToVehicleUpdate(onFinish: @escaping () async -> Void, vehicle: Vehicle) {
        self.onFinish = onFinish
        history.append(.vehicleUpdate)
    }
    
    func goingBackToHomeView() {
        history.append(.myVehicles)
    }
    
    enum History: CustomDebugStringConvertible, Equatable {
        case myVehicles
        case vehicleCreation
        case profile
        case vehicleUpdate
        
        var debugDescription: String {
            switch self {
            case .myVehicles: return "My vehicles"
            case .vehicleCreation: return "vehicle creation"
            case .profile: return "profile"
            case .vehicleUpdate: return "vehicle update"
            }
        }
    }
}
