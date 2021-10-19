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
    private var cancellables = Set<AnyCancellable>()
    
    var alertText: VehicleCreationError = .unknow
    var showAlert = false
    
    @Published var brand: String = ""
    @Published var model: String = ""
    @Published var immatriculation: String = ""
    @Published var licenceNumber: String = ""
    @Published var year: String = ""
    @Published var type: VehicleType = .car
    
    init(vehicleCreator: VehicleCreator = VehicleCreator(), vehicleVerificator: VehicleInformationsVerificator = VehicleInformationsVerificator()) {
        self.vehicleCreator = vehicleCreator
        self.vehicleInformationsVerificator = vehicleVerificator
    }
    
    func createVehicle(with informations: VehicleInformations) {
        if let error = vehicleInformationsVerificator.checkingInformations(vehicle: informations) {
            alertText = error
            showAlert = true
            return
        }
        
        vehicleCreator.createVehicle(informations: informations).sink(receiveCompletion: {
            if case .failure = $0 {
                self.alertText = .unknow
                self.showAlert = true
            }
        }, receiveValue: {
            print("Done")
        }).store(in: &cancellables)
    }
}
