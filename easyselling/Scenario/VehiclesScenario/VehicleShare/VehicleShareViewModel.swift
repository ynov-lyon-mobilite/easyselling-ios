//
//  VehicleShareViewModel.swift
//  easyselling
//
//  Created by Théo Tanchoux on 16/02/2022.
//

import Foundation

class VehicleShareViewModel: ObservableObject {

    init(vehicleGetter: VehicleGetter = DefaultVehicleGetter(),
         vehicleId: String = "") {
        self.vehicleGetter = vehicleGetter
        self.vehicleId = vehicleId
    }

    private var vehicleGetter: VehicleGetter
    private var vehicleId: String

    @Published var isLoading: Bool = true
    @Published var email: String = ""
    @Published var error: APICallerError?
    @Published var state: VehicleState = .loading
    @Published var vehicle: Vehicle?
    @MainActor func getVehicle() async {
        state = .loading
        do {
            vehicle = try await vehicleGetter.getVehicle(id: self.vehicleId)
            state = .displayingVehicle
        } catch (let error) {
            state = .error
            if let error = error as? APICallerError {
                self.error = error
            }
        }
    }

    enum VehicleState {
        case loading
        case displayingVehicle
        case error
    }
}
