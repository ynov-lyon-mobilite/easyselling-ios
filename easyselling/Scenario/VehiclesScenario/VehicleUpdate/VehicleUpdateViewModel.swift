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

    @Published var brand: String = ""
    @Published var model: String = ""
    @Published var licence: String = ""
    @Published var type: Vehicle.Category = .car
    @Published var year: String = ""

    init(vehicle: Vehicle,
         onFinish: @escaping () async -> Void,
         vehicleVerificator: VehicleInformationsVerificator = DefaultVehicleInformationsVerificator(),
         vehicleUpdater: VehicleUpdater = DefaultVehicleUpdater(context: mainContext)) {
        self.vehicle = vehicle
        self.onFinish = onFinish
        self.vehicleInformationsVerificator = vehicleVerificator
        self.vehicleUpdater = vehicleUpdater

        self.brand = vehicle.brand
        self.model = vehicle.model
        self.licence = vehicle.licence
        self.type = vehicle.type
        self.year = vehicle.year

    }

    @MainActor
    func updateVehicle() async {
        let newInformations = Vehicle(id: vehicle.id, brand: brand, model: model, licence: licence, type: type, year: year)

        do {
            try vehicleInformationsVerificator.verifyInformations(vehicle: newInformations.toDTO())
            try await vehicleUpdater.updateVehicle(informations: newInformations)
            await onFinish()
        } catch (let error) {
            self.alert = (error as? VehicleCreationError)?.errorDescription
            ?? (error as? APICallerError)?.errorDescription
            ?? APICallerError.internalServerError.errorDescription ?? ""
            self.showAlert =  true
        }
    }
}
