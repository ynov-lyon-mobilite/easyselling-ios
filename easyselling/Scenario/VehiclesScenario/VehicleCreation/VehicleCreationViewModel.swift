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
    @Published var type: Vehicle.Category = .unknow
    var createdVehicle: Vehicle = Vehicle(brand: "", model: "", license: "", type: .unknow, year: "")

    var title: String {
        switch vehicleCreationStep {
        case .vehicleType: return "Mon type de véhicule"
        case .licence: return "Ma plaque d'immatriculation"
        case .brandAndModel: return "Marque et modèle"
        case .year: return "Année d'immatriculation"
        }
    }

    var vehiclesTypes: [String] = ["Une voiture", "Une moto"]

    var vehicleCreationStep: VehicleCreationStep = .vehicleType

    init(vehicleCreator: VehicleCreator = DefaultVehicleCreator(), vehicleVerificator: VehicleInformationsVerificator = DefaultVehicleInformationsVerificator(),
         onFinish: @escaping () async -> Void) {
        self.vehicleCreator = vehicleCreator
        self.vehicleInformationsVerificator = vehicleVerificator
        self.onFinish = onFinish
    }

    @MainActor func createVehicle() async {
        let informations = VehicleDTO(brand: brand, model: model, license: license, type: type, year: year)
}
    func continueVehicleCreation() {
        switch vehicleCreationStep {
        case .vehicleType:
            self.createdVehicle.type = self.type
            self.vehicleCreationStep = .licence
        case .licence:
            let vehicleVerificator = DefaultVehicleVerificator()
            do {
                try vehicleVerificator.verifyLicenseFormat(license: self.license)
                try vehicleVerificator.verifyLicenseSize(license: self.license)
                self.createdVehicle.license = self.license
                self.vehicleCreationStep = .brandAndModel
            } catch (let error) {
                
            }
        case .brandAndModel:
            self.createdVehicle.brand = self.brand
            self.createdVehicle.model = self.model
            self.vehicleCreationStep = .year
        case .year:
            break
        }
    }

    func dismissModal() async {
        await self.onFinish()
    }

    enum VehicleCreationStep {
        case vehicleType
        case licence
        case brandAndModel
        case year
    }
}
