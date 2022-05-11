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
         sharedVehiclesGetter: SharedVehiclesGetter = DefaultSharedVehiclesGetter(),
         vehicleDeletor: VehicleDeletor = DefaultVehicleDeletor(context: mainContext),
         isOpeningVehicleUpdate: @escaping OnUpdatingVehicle,
         isNavigatingToInvoices: @escaping (Vehicle) -> Void,
         isOpeningVehicleShare: @escaping (Vehicle) -> Void) {

        self.vehiclesGetter = vehiclesGetter
        self.sharedVehiclesGetter = sharedVehiclesGetter
        self.vehicleDeletor = vehicleDeletor
        self.isOpeningVehicleUpdate = isOpeningVehicleUpdate
        self.isNavigatingToInvoices = isNavigatingToInvoices
        self.isOpeningVehicleShare = isOpeningVehicleShare
    }

    private var vehiclesGetter: VehiclesGetter
    private var sharedVehiclesGetter: SharedVehiclesGetter
    private var vehicleDeletor: VehicleDeletor
    private var isOpeningVehicleUpdate: OnUpdatingVehicle
    private var isNavigatingToInvoices: (Vehicle) -> Void
    private var isOpeningVehicleShare: (Vehicle) -> Void

    @Published var isOpenningVehicleCreation: Bool = false
    @Published var vehicles: [Vehicle] = [.placeholderCar, .placeholderMoto]
    @Published var sharedVehicles: [Vehicle] = []
    @Published var error: APICallerError?
    @Published var state: VehicleState = .loading
    @Published var searchFilteringVehicle = ""
    @Published var showSharedVehicles: Bool = false

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

    func openVehicleShare(vehicle: Vehicle) {
        self.isOpeningVehicleShare(vehicle)
    }

    @MainActor func getVehicles() async {
        do {
            vehicles = try await vehiclesGetter.getVehicles()
            setState(.listingVehicles)
//            await getSharedVehicles()
        } catch (let error) {
            setError(error)
        }
    }

    @MainActor func deleteVehicle(idVehicle: String) async {
        do {
            try await vehicleDeletor.deleteVehicle(id: idVehicle)
            deleteVehicleOnTheView(idVehicle: idVehicle)
        } catch (let error) {
            setError(error)
        }
    }

    @MainActor
    func getSharedVehicles() async {
        do {
            sharedVehicles = try await sharedVehiclesGetter.getSharedVehicles()
            if !sharedVehicles.isEmpty {
                showSharedVehicles = true
            }
        } catch(let error) {
            setError(error)
        }
    }

    private func deleteVehicleOnTheView(idVehicle: String) {
        vehicles = vehicles.filter { (vehicle) -> Bool in
            vehicle.id != idVehicle
        }
    }

    private func setError(_ error: Error) {
        setState(.error)
        withAnimation(.easeInOut(duration: 0.2)) {
        	if let error = error as? APICallerError {
            	self.error = error
        	}
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.error = nil
                }
            }
        }
    }

    func navigatesToInvoices(vehicle: Vehicle) {
        self.isNavigatingToInvoices(vehicle)
    }

    private func setState(_ state: VehicleState) {
        self.state = state
    }

    enum VehicleState {
        case loading
        case listingVehicles
        case sharedVehicles
        case error
    }
}
