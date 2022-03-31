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
         isOpenningVehicleCreation: @escaping Action,
         isOpeningVehicleUpdate: @escaping OnUpdatingVehicle,
         isNavigatingToProfile: @escaping Action,
         isNavigatingToInvoices: @escaping (Vehicle) -> Void) {

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
    private var isNavigatingToInvoices: (Vehicle) -> Void

    @Published var isLoading: Bool = true
    @Published var vehicles: [Vehicle] = []
    @Published var error: APICallerError?
    @Published var state: VehicleState = .loading

    @Published var searchFilteringVehicle = ""

    var filteredVehicle: [Vehicle] {
        return vehicles.filter { [searchFilteringVehicle] vehicle in
            if (searchFilteringVehicle.isEmpty) {
                return true
            }

            return vehicle.brand.contains(searchFilteringVehicle)
            || vehicle.model.contains(searchFilteringVehicle)
            || vehicle.type.rawValue.contains(searchFilteringVehicle)
        }
    }

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
            deleteVehicleOnTheView(idVehicle: idVehicle)
        } catch (let error) {
            if let error = error as? APICallerError {
                self.error = error
            }
        }
    }

    private func deleteVehicleOnTheView(idVehicle: String) {
        vehicles = vehicles.filter { (vehicle) -> Bool in
            vehicle.id != idVehicle
        }
    }

    enum VehicleState {
        case loading
        case listingVehicles
        case error
    }

    func navigatesToInvoices(vehicle: Vehicle) {
        self.isNavigatingToInvoices(vehicle)
    }
}
