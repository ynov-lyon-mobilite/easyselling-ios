//
//  ModelSelectionViewModel.swift
//  easyselling
//
//  Created by Lucas Barthélémy on 06/05/2022.
//

import Foundation
import SwiftUI

class ModelSelectionViewModel: ObservableObject {

    init(vehicleModelGetter: VehicleModelGetter = DefaultVehicleModelGetter(), brandSelected: Brand, hasSelectedModel: @escaping (String) -> Void) {
        self.vehicleModelGetter = vehicleModelGetter
        self.brandSelected = brandSelected
        self.hasSelectedModel = hasSelectedModel
    }

    private var vehicleModelGetter: VehicleModelGetter
    private var brandSelected: Brand
    private var hasSelectedModel: (String) -> Void

    @Published var alert: String = ""
    @Published var showAlert = false

    @Published var model: String = ""
    @Published var searchModel: String = ""

    @Published var vehicleModel: [Model] = []

    var searchModelResults: [Model] {
        if searchModel.isEmpty {
            return vehicleModel.filter { $0.brand == brandSelected.id }
        } else {
            return vehicleModel.filter { $0.brand == brandSelected.id && $0.model.uppercased().hasPrefix(searchModel.uppercased())}
        }
    }

    @MainActor
    func getVehicleModel() async {
        do {
            vehicleModel = try await vehicleModelGetter.getVehicleModel()
            vehicleModel = vehicleModel.sorted { $0.model < $1.model }
        } catch (let error) {
            print(error)
        }
    }

    func dismissSelector() {
        hasSelectedModel(model)
    }
}
