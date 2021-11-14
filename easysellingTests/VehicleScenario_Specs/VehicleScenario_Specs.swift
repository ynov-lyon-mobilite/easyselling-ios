//
//  VehicleScenario_Spec.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 25/10/2021.
//

import UIKit
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
    
    func test_Leaves_vehicle_creation() async {
        givenScenario()
        whenBeginning()
        whenNavigatingToVehicleCreation()
        await navigator.onFinish?()
        thenHistory(is: [.myVehicles, .vehicleCreation, .myVehicles])
    }
    
    private func givenScenario() {
        navigator = SpyVehicleCreationNavigator()
        scenario = VehicleScenario(navigator: navigator)
    }
    
    private func whenBeginning() {
        scenario.begin()
    }
    
    private func whenNavigatingToVehicleCreation() {
        scenario.navigatesToVehicleCreation()
    }
    
    private func whenleavingVehicleCreation() async {
        await navigator.onFinish?()
    }

    private func thenHistory(is expected: [SpyVehicleCreationNavigator.History]) {
        XCTAssertEqual(expected, navigator.history)
    }
    
    private var scenario: VehicleScenario!
    private var navigator: SpyVehicleCreationNavigator!
    private var isVehicleCreationFinished: Bool!
}

class SpyVehicleCreationNavigator: VehicleNavigator {
   
    private(set) var history: [History] = []
    private(set) var onFinish: (() async -> Void)?
    
    func navigatesToHomeView(onVehicleCreationOpen: @escaping Action) {
        history.append(.myVehicles)
    }
    
    func navigatesToVehicleCreation(onFinish: @escaping () async -> Void) {
        self.onFinish = onFinish
        history.append(.vehicleCreation)
    }
    
    func goingBackToHomeView() {
        history.append(.myVehicles)
    }
    
    enum History: CustomDebugStringConvertible, Equatable {
        case myVehicles
        case vehicleCreation
        
        var debugDescription: String {
            switch self {
            case .myVehicles: return "My vehicles"
            case .vehicleCreation: return "vehicle creation"
            }
        }

    }
}
