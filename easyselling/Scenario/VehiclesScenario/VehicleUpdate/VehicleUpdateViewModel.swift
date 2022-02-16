//
//  VehicleUpdateViewModel.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 18/11/2021.
//

import Foundation

class VehicleUpdateViewModel: ObservableObject {

    private(set) var vehicle: Vehicle
    private(set) var onFinish: () async -> Void
    private var vehicleInformationsVerificator: VehicleInformationsVerificator
    private var vehicleUpdater: VehicleUpdater

    @Published var alert: String = ""
    @Published var showAlert = false

    @Published var brand: String
    @Published var model: String
    @Published var license: String
    @Published var type: Vehicle.Category
    @Published var year: String

    init(vehicle: Vehicle, onFinish: @escaping () async -> Void,
         vehicleVerificator: VehicleInformationsVerificator = DefaultVehicleInformationsVerificator(),
         vehicleUpdater: VehicleUpdater = DefaultVehicleUpdater()) {
        self.vehicle = vehicle
        self.onFinish = onFinish
        self.vehicleInformationsVerificator = vehicleVerificator
        self.vehicleUpdater = vehicleUpdater

        self.brand = vehicle.brand
        self.model = vehicle.model
        self.license = vehicle.license
        self.type = vehicle.type
        self.year = vehicle.year
    }

    @MainActor
    func updateVehicle() async {
        guard let id = vehicle.id else { return }

        let newInformations = VehicleDTO(brand: brand, license: license, model: model, type: type.rawValue, year: year)

        do {
            try vehicleInformationsVerificator.verifyInformations(vehicle: newInformations)
            try await vehicleUpdater.updateVehicle(id: id, informations: newInformations)
            await onFinish()
        } catch (let error) {
            self.alert = (error as? VehicleCreationError)?.description ?? (error as? APICallerError)?.errorDescription ?? APICallerError.internalServerError.errorDescription ?? ""
            self.showAlert =  true
        }
    }
}
