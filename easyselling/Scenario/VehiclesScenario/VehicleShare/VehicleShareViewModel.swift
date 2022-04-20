//
//  VehicleShareViewModel.swift
//  easyselling
//
//  Created by Théo Tanchoux on 16/02/2022.
//

import Foundation

class VehicleShareViewModel: ObservableObject {

    init(vehicle: Vehicle, vehicleShare: VehicleShare = DefaultVehicleShare()) {
        self.vehicle = vehicle
        self.vehicleShare = vehicleShare
    }
    private var vehicleShare: VehicleShare
    @Published var email: String = ""
    @Published var error: APICallerError?
    @Published var vehicle: Vehicle
    @Published var state: ShareState = .sharingVehicle

    @MainActor func shareVehicle() async {
        state = .loading
        do {
            try await vehicleShare.shareVehicle(id: vehicle.id, email: email)
            if error != nil {
                error = nil
            }
        } catch (let error) {
            if let error = error as? APICallerError {
                self.error = error
            }
        }
        state = .sharingVehicle
    }

    enum ShareState {
        case loading
        case sharingVehicle
    }
}
