//
//  MyVehiclesViewModel.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 25/10/2021.
//

import Foundation
import SwiftUI

class MyVehiclesViewModel: ObservableObject {

    init(vehiclesGetter: VehiclesGetter = DefaultVehiclesGetter(),
         vehicleDeletor: VehicleDeletor = DefaultVehicleDeletor(),
         isOpenningVehicleCreation: @escaping Action, isOpeningVehicleUpdate: @escaping OnUpdatingVehicle,
         isNavigatingToProfile: @escaping Action,
         isNavigatingToInvoices: @escaping (String) -> Void) {
        self.vehiclesGetter = vehiclesGetter
        self.vehicleDeletor = vehicleDeletor
        self.isOpenningVehicleCreation = isOpenningVehicleCreation
		self.isOpeningVehicleUpdate = isOpeningVehicleUpdate
        self.isNavigatingToProfile = isNavigatingToProfile
        self.isNavigatingToInvoices = isNavigatingToInvoices
    }

    private var vehiclesGetter: VehiclesGetter
	private var isOpeningVehicleUpdate: OnUpdatingVehicle
    private var vehicleDeletor: VehicleDeletor
    private var isOpenningVehicleCreation: Action
    private var isNavigatingToProfile: Action
    private var isNavigatingToInvoices: (String) -> Void

    @Published var isLoading: Bool = true
    @Published var vehicles: [Vehicle] = []
    @Published var error: APICallerError?
    @Published var state: VehicleState = .loading

    func openVehicleCreation() {
        self.isOpenningVehicleCreation()
    }

    func openVehicleUpdate(vehicle: Vehicle) {
        self.isOpeningVehicleUpdate(vehicle, { await self.getVehicles() })
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
        do {
            try await vehicleDeletor.deleteVehicle(id: idVehicle)
            await updateVehiclesList()
        } catch (let error) {
            if let error = error as? APICallerError {
                self.error = error
            }
        }
    }

    func updateVehiclesList() async {
        await getVehicles()
    }

    enum VehicleState {
        case loading
        case listingVehicles
        case error
    }

    func navigatesToInvoices(ofVehicle vehicleId: String) {
        self.isNavigatingToInvoices(vehicleId)
    }
}
