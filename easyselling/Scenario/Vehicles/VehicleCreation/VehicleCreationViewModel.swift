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

    @Published var alertText: String = ""
    @Published var showAlert = false

    @Published var brand: String = "Audi"
    @Published var model: String = "A1"
    @Published var license: String = "123456789"
    @Published var year: String = "2005"
    @Published var type: VehicleType = .carType

    init(vehicleCreator: VehicleCreatorProtocol, vehicleVerificator: VehicleInformationsProtocol,
         onFinish: @escaping Action) {
        self.vehicleCreator = vehicleCreator
        self.vehicleInformationsVerificator = vehicleVerificator
        self.onFinish = onFinish
    }

    func createVehicle() async {
        let informations = VehicleInformations(license: license, brand: brand, type: type.rawValue, year: year, model: model)
        if let error = vehicleInformationsVerificator.checkingInformations(vehicle: informations) {
            self.alertText = error.errorDescription ?? ""
            self.showAlert = true
            return
        }

        do {
            try await vehicleCreator.createVehicle(informations: informations)
            self.onFinish()
        } catch(let error) {
            self.alertText = (error as? APICallerError)?.errorDescription ?? APICallerError.internalServerError.errorDescription ?? ""
            self.showAlert = true
        }
    }
}
