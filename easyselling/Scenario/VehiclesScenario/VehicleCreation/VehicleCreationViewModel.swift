//
//  VehicleCreationViewModel.swift
//  easyselling
//
//  Created by Valentin Mont School on 17/10/2021.
//
import Foundation
import Combine
import SwiftUI

class VehicleCreationViewModel: ObservableObject {

    init(vehicleCreator: VehicleCreator = DefaultVehicleCreator(),
         vehicleVerificator: VehicleInformationsVerificator = DefaultVehicleInformationsVerificator(),
         isOpenningVehicleCreation: Binding<Bool>) {
        self.vehicleCreator = vehicleCreator
        self.vehicleInformationsVerificator = vehicleVerificator
        self.isOpenningVehicleCreation = isOpenningVehicleCreation
    }

    private var vehicleCreator: VehicleCreator
    private var vehicleInformationsVerificator: VehicleInformationsVerificator

    var isOpenningVehicleCreation: Binding<Bool>
    @Published var error: LocalizedError?
    @Published var showAlert = false
    @Published var brand: String = ""
    @Published var model: String = ""
    @Published var license: String = ""
    @Published var year: String = ""
    @Published var vehicleCreationStep: VehicleCreationStep = .vehicleType

    var createdVehicle: Vehicle = Vehicle(brand: "", model: "", license: "", type: .unknow, year: "")

    var title: String {
        withAnimation(.easeInOut(duration: 0.4)) {
            switch vehicleCreationStep {
            case .vehicleType: return "Mon type de véhicule"
            case .licence: return "Ma plaque d'immatriculation"
            case .brandAndModel: return "Marque et modèle"
            case .year: return "Année d'immatriculation"
            }
        }
    }

    @Published var type: Vehicle.Category = .unknow

    func selectType(_ type: Vehicle.Category) {
        self.type = type

    }

    @MainActor func createVehicle() async {
        let informations = VehicleDTO(brand: brand, model: model, license: license, type: type, year: year)
}
    func continueVehicleCreation() {
        withAnimation(.easeInOut(duration: 0.4)) {
            switch vehicleCreationStep {
            case .vehicleType:
                do {
                    try verifyType()
                    self.createdVehicle.type = self.type
                    self.vehicleCreationStep = .licence
                } catch (let error) {
                    if let error = error as? VehicleCreationError {
                        self.error = error
                    }
                }
            case .licence:
                do {
                    try vehicleInformationsVerificator.verifyLicence(self.license)
                    self.createdVehicle.license = self.license
                    self.vehicleCreationStep = .brandAndModel
                } catch (let error) {
                    if let error = error as? VehicleCreationError {
                        self.error = error
                    }
                }
            case .brandAndModel:
                self.createdVehicle.brand = self.brand
                self.createdVehicle.model = self.model
                self.vehicleCreationStep = .year
            case .year:
                break
            }
        }
    }

    func goingToPrevious() {
        withAnimation {
            switch vehicleCreationStep {
            case .vehicleType: break
            case .licence: self.vehicleCreationStep = .vehicleType
            case .brandAndModel: self.vehicleCreationStep = .licence
            case .year: self.vehicleCreationStep = .brandAndModel
            }
        }
    }

    func dismissModal() {
        withAnimation(.easeInOut(duration: 0.4)) {
            isOpenningVehicleCreation.wrappedValue.toggle()
        }
    }

    private func verifyType() throws {
        if self.type == .unknow {
            throw VehicleCreationError.unchosenType
        }
        return
    }

    enum VehicleCreationStep: CaseIterable {
        case vehicleType
        case licence
        case brandAndModel
        case year

        var count: Int {
            VehicleCreationStep.allCases.count
        }

        var currentIndex: Int {
            switch self {
            case .vehicleType: return 0
            case .licence: return 1
            case .brandAndModel: return 2
            case .year: return 3
            }
        }
    }
}
