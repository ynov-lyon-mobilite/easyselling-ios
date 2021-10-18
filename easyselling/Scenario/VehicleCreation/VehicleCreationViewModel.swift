//
//  VehicleCreationViewModel.swift
//  easyselling
//
//  Created by Valentin Mont School on 17/10/2021.
//

import Foundation
import Combine

class VehicleCreationViewModel {
    
    private var vehicleCreator: VehicleCreator
    private var vehicleInformationsVerificator: VehicleInformationsVerificator
    private var cancellables = Set<AnyCancellable>()
    
    var alert: String = ""
    var showAlert = false
    
    init(vehicleCreator: VehicleCreator = VehicleCreator(), vehicleVerificator: VehicleInformationsVerificator = VehicleInformationsVerificator()) {
        self.vehicleCreator = vehicleCreator
        self.vehicleInformationsVerificator = vehicleVerificator
    }
    
    func createVehicle(with informations: VehicleInformations) {
        //guard vehicleInformationsVerificator.checkingInformations(vehicle: informations) else { return }
        vehicleCreator.createVehicle(informations: informations).sink(receiveCompletion: {
            if case let .failure(error) = $0 {
                self.alert = error.localizedDescription
                self.showAlert = true
            }
        }, receiveValue: {
            print("Done")
        }).store(in: &cancellables)
    }
}
