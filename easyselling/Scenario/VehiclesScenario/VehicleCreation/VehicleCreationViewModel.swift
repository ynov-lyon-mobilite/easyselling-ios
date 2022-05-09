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

    init(vehicleCreator: VehicleCreator = DefaultVehicleCreator(context: mainContext),
         vehicleVerificator: VehicleInformationsVerificator = DefaultVehicleInformationsVerificator(),
         vehicleBrandGetter: VehicleBrandGetter = DefaultVehicleBrandGetter(),
         vehicleModelGetter: VehicleModelGetter = DefaultVehicleModelGetter(),
         hasFinishedVehicleCreation: @escaping () -> Void) {
        self.vehicleCreator = vehicleCreator
        self.vehicleInformationsVerificator = vehicleVerificator
        self.vehicleBrandGetter = vehicleBrandGetter
        self.vehicleModelGetter = vehicleModelGetter
        self.hasFinishedVehicleCreation = hasFinishedVehicleCreation
    }

    private var vehicleCreator: VehicleCreator
    private var vehicleInformationsVerificator: VehicleInformationsVerificator
    private var vehicleBrandGetter: VehicleBrandGetter
    private var vehicleModelGetter: VehicleModelGetter

    private var hasFinishedVehicleCreation: () -> Void

    @Published var error: LocalizedError?
    @Published var showAlert = false

    @Published var brand: String = ""
    @Published var model: String = ""
    @Published var licence: String = ""
    @Published var year: String = ""
    @Published var vehicleCreationStep: VehicleCreationStep = .vehicleType

    @Published var isShowingSelectionBrand: Bool = false
    @Published var isShowingSelectionModel: Bool = false

    @Published var searchBrand: String = ""
    @Published var brandSelected: Brand = Brand(id: "", name: "")

    @Published var searchModel: String = ""

    func showSelectionBrand() {
        isShowingSelectionBrand = true
    }

    func showSelectionModel() {
        isShowingSelectionModel = true
    }

    var rangeOfYears: [String] {
        let actualDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        guard let year = Int(dateFormatter.string(from: actualDate)) else { return [] }
        return (1900...year).reversed().map { String($0) }
    }

    var createdVehicle: Vehicle = Vehicle(id: "", brand: "", model: "", licence: "", type: .unknow, year: "")

    var title: String {
        withAnimation(.easeInOut(duration: 0.4)) {
            switch vehicleCreationStep {
            case .vehicleType: return L10n.CreateVehicle.Form.VehicleType.title
            case .licence: return L10n.CreateVehicle.Form.Licence.title
            case .brandAndModel: return L10n.CreateVehicle.Form.BrandAndModel.title
            case .year: return L10n.CreateVehicle.Form.Year.title
            }
        }
    }

    @Published var type: Vehicle.Category = .unknow

    func selectType(_ type: Vehicle.Category) {
        self.type = type
        continueVehicleCreation()
    }

    @MainActor
    func createVehicle() async {
        let informations = VehicleDTO(brand: brand, licence: licence, model: model, type: type, year: year)
        do {
            try vehicleInformationsVerificator.verifyInformations(vehicle: informations)
            try await vehicleCreator.createVehicle(informations: informations)
            dismissModal()
        } catch (let error) {

            if let error = error as? VehicleCreationError {
                setError(with: error)
            }
            if let error = error as? APICallerError {
                setError(with: error)
            }
        }
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
                        setError(with: error)
                    }
                }
            case .licence:
                do {
                    try vehicleInformationsVerificator.verifyLicence(self.licence)
                    self.createdVehicle.licence = self.licence
                    self.vehicleCreationStep = .brandAndModel
                } catch (let error) {
                    if let error = error as? VehicleCreationError {
                        setError(with: error)
                    }
                }
            case .brandAndModel:
                do {
                    try verifyBrandAndModel()
                    self.createdVehicle.brand = self.brand
                    self.createdVehicle.model = self.model
                    self.vehicleCreationStep = .year
                } catch (let error) {
                    if let error = error as? VehicleCreationError {
                        setError(with: error)
                    }
                }
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
            hasFinishedVehicleCreation()
        }
    }

    private func setError(with error: LocalizedError) {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.error = error
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.error = nil
                }
            }
        }
    }

    private func verifyType() throws {
        if self.type == .unknow {
            throw VehicleCreationError.unchosenType
        }
        return
    }

    func verifyBrandAndModel() throws {
        if brand.isEmpty || model.isEmpty {
            throw VehicleCreationError.unchosenVehicleBrandAndModel
        }
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
