//
//  MyVehiclesViewModel.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 25/10/2021.
//

import Foundation
import UIKit
import SwiftUI

class MyVehiclesViewModel: ObservableObject {

    init(vehiclesGetter: VehiclesGetter = DefaultVehiclesGetter(),
         isOpenningVehicleCreation: @escaping Action,
         isNavigatingToProfile: @escaping Action) {
        self.vehiclesGetter = vehiclesGetter
        self.isOpenningVehicleCreation = isOpenningVehicleCreation
        self.isNavigatingToProfile = isNavigatingToProfile
    }

    private var vehiclesGetter: VehiclesGetter
    private var isOpenningVehicleCreation: Action
    private var isNavigatingToProfile: Action
    @Published var vehicles: [Vehicle] = []
    @Published var error: APICallerError?
    @Published var state: VehicleState = .loading

    func openVehicleCreation() {
        self.isOpenningVehicleCreation()
    }

    @MainActor func getVehicles() async {
        state = .loading
        do {
            vehicles = try await vehiclesGetter.getVehicles()
            state = .listingVehicles
        } catch (let error) {
            state = .error
            if let error = error as? APICallerError {
                self.error = error
            }
        }
    }

    func navigateToProfile() {
        self.isNavigatingToProfile()
    }

    func updateVehiclesList() async {
       await getVehicles()
    }

    enum VehicleState {
        case loading
        case listingVehicles
        case error
    }
}
