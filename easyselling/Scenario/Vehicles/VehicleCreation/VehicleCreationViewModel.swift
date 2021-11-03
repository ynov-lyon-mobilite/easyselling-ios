//
//  VehicleCreationViewModel.swift
//  easyselling
//
//  Created by Valentin Mont School on 17/10/2021.
//

import Foundation
import Combine

class VehicleCreationViewModel: ObservableObject {
    
    private var vehicleCreator: VehicleCreatorProtocol
    private var vehicleInformationsVerificator: VehicleInformationsProtocol
    private var onFinish: Action

    @Published var alert: String = ""
    @Published var showAlert = false

    @Published var brand: String = ""
    @Published var model: String = ""
    @Published var license: String = ""
    @Published var year: String = ""
    @Published var type: VehicleType = .carType

    init(vehicleCreator: VehicleCreatorProtocol, vehicleVerificator: VehicleInformationsProtocol,
         onFinish: @escaping Action) {
        self.vehicleCreator = vehicleCreator
        self.vehicleInformationsVerificator = vehicleVerificator
        self.onFinish = onFinish
    }

    func createVehicle() async {
        let informations = VehicleInformations(license: license, brand: brand, type: type.rawValue, year: year, model: model)
        if let error = vehicleInformationsVerificator.verifyInformations(vehicle: informations) {
            self.alert = error.errorDescription ?? ""
            self.showAlert = true
            return
        }

        do {
            try await vehicleCreator.createVehicle(informations: informations)
            self.onFinish()
        } catch(let error) {
            self.alert = (error as? APICallerError)?.errorDescription ?? APICallerError.internalServerError.errorDescription ?? ""
            self.showAlert = true
        }
    }
}
