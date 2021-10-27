//
//  VehicleCreationViewModel.swift
//  easyselling
//
//  Created by Valentin Mont School on 17/10/2021.
//

import Foundation
import Combine

class VehicleCreationViewModel: ObservableObject {
    
    init(onFinish: @escaping Action) {
        self.onFinish = onFinish
    }
    
    private var onFinish: Action
    
    func createVehicle() {
        self.onFinish()
    }
    
    //    private var vehicleCreator: VehicleCreator
//    private var vehicleInformationsVerificator: VehicleInformationsVerificator
//    private var cancellables = Set<AnyCancellable>()
//    private var onFinish: Action
//
//    @Published var alertText: String = ""
//    @Published var showAlert = false
//
//    @Published var brand: String = ""
//    @Published var model: String = ""
//    @Published var license: String = ""
//    @Published var year: String = ""
//    @Published var type: VehicleType = .carType
//
//    init(vehicleCreator: VehicleCreator = VehicleCreator(), vehicleVerificator: VehicleInformationsVerificator = VehicleInformationsVerificator(),
//         onFinish: @escaping Action) {
//        self.vehicleCreator = vehicleCreator
//        self.vehicleInformationsVerificator = vehicleVerificator
//        self.onFinish = onFinish
//    }
//
//    func createVehicle(with informations: VehicleInformations) async {
//        if let error = vehicleInformationsVerificator.checkingInformations(vehicle: informations) {
//            DispatchQueue.main.async {
//                self.alertText = error.errorDescription ?? ""
//                self.showAlert = true
//            }
//            return
//        }
//
//        do {
//            try await vehicleCreator.createVehicle(informations: informations)
//        } catch(let error) {
//            DispatchQueue.main.async {
//                self.alertText = (error as? APICallerError)?.errorDescription ?? APICallerError.internalServerError.errorDescription ?? ""
//                self.showAlert = true
//            }
//        }
//    }
}
