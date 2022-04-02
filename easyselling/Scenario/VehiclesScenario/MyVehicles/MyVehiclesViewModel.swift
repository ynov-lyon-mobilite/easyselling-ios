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
         isOpeningVehicleUpdate: @escaping OnUpdatingVehicle,
         isNavigatingToInvoices: @escaping (Vehicle) -> Void) {

        self.vehiclesGetter = vehiclesGetter
        self.vehicleDeletor = vehicleDeletor
        self.isOpeningVehicleUpdate = isOpeningVehicleUpdate
        self.isNavigatingToInvoices = isNavigatingToInvoices
    }

    private var vehiclesGetter: VehiclesGetter
    private var isOpeningVehicleUpdate: OnUpdatingVehicle
    private var vehicleDeletor: VehicleDeletor
    private var isNavigatingToInvoices: (Vehicle) -> Void

    @Published var isOpenningVehicleCreation: Bool = false
    @Published var vehicles: [Vehicle] = [.placeholderCar, .placeholderMoto]
    @Published var error: APICallerError?
    @Published var state: VehicleState = .loading

    @Published var searchFilteringVehicle = ""

    var filteredVehicle: [Vehicle] {
        return vehicles.filter { [searchFilteringVehicle] vehicle in
            if searchFilteringVehicle.isEmpty {
                return true
            }

            return vehicle.brand.contains(searchFilteringVehicle)
            || vehicle.model.contains(searchFilteringVehicle)
            || vehicle.type.rawValue.contains(searchFilteringVehicle)
        }
    }

    func openVehicleCreation() {
        withAnimation(.easeInOut(duration: 0.4)) {
            isOpenningVehicleCreation = true
        }
    }

    func openVehicleUpdate(vehicle: Vehicle) {
        self.isOpeningVehicleUpdate(vehicle, { await self.getVehicles() })
    }

    @MainActor func getVehicles() async {
        setState(.loading)
        do {
            vehicles = try await vehiclesGetter.getVehicles()
            setState(.listingVehicles)
        } catch (let error) {
            setState(.error)
            if let error = error as? APICallerError {
                self.error = error
            }
        }
    }

    @MainActor func deleteVehicle(idVehicle: String) async {
        do {
            try await vehicleDeletor.deleteVehicle(id: idVehicle)
            deleteVehicleOnTheView(idVehicle: idVehicle)
        } catch (let error) {
            setState(.error)
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

    private func setState(_ state: VehicleState) {
        self.state = state
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
