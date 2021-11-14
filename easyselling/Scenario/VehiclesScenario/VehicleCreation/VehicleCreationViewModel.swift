//
//  VehicleCreationViewModel.swift
//  easyselling
//
//  Created by Valentin Mont School on 17/10/2021.
//

import Foundation
import Combine

class VehicleCreationViewModel: ObservableObject {
    
    private var vehicleCreator: VehicleCreator
    private var vehicleInformationsVerificator: VehicleInformationsVerificator
    private var onFinish: () async -> Void

    @Published var alert: String = ""
    @Published var showAlert = false

    @Published var brand: String = ""
    @Published var model: String = ""
    @Published var license: String = ""
    @Published var year: String = ""
    @Published var type: Vehicle.Category = .car

    init(vehicleCreator: VehicleCreator, vehicleVerificator: VehicleInformationsVerificator,
         onFinish: @escaping () async -> Void) {
        self.vehicleCreator = vehicleCreator
        self.vehicleInformationsVerificator = vehicleVerificator
        self.onFinish = onFinish
    }

    @MainActor func createVehicle() async {
        let informations = Vehicle(brand: brand, model: model, license: license, type: type, year: year)
        
        do {
            let informationsVerified = try vehicleInformationsVerificator.verifyInformations(vehicle: informations)
            try await vehicleCreator.createVehicle(informations: informationsVerified)
            await dismissModal()
        } catch (let error) {
            self.alert = (error as? VehicleCreationError)?.description ?? (error as? APICallerError)?.errorDescription ?? APICallerError.internalServerError.errorDescription ?? ""
            self.showAlert = true
        }
    }
    
    func dismissModal() async {
        await self.onFinish()
    }
}
