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
vehicleDeletor: VehicleDeletor = DefaultVehicleDeletor(),
         isOpenningVehicleCreation: @escaping Action,
         isNavigatingToProfile: @escaping Action) {
        self.vehiclesGetter = vehiclesGetter
        self.vehicleDeletor = vehicleDeletor
        self.isOpenningVehicleCreation = isOpenningVehicleCreation
        self.isNavigatingToProfile = isNavigatingToProfile
    }

    private var vehiclesGetter: VehiclesGetter
    private var vehicleDeletor: VehicleDeletor
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

    @MainActor func deleteVehicle(idVehicle: String) async {
        print("JE DELETE")
        do {
            try await vehicleDeletor.deleteVehicle(id: idVehicle)
            await updateVehiclesList()
        } catch (let error) {
            if let error = error as? APICallerError {
                isError = true
                self.error = error
            } else {
                self.error = nil
            }
        }
        
        isLoading = false
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
