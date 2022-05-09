//
//  BrandSelectionViewModel.swift
//  easyselling
//
//  Created by Lucas Barthélémy on 06/05/2022.
//

import Foundation
import SwiftUI

class BrandSelectionViewModel: ObservableObject {

    init(vehicleBrandGetter: VehicleBrandGetter = DefaultVehicleBrandGetter(), hasSelectedBrand: @escaping (Brand) -> Void) {
        self.vehicleBrandGetter = vehicleBrandGetter
        self.hasSelectedBrand = hasSelectedBrand
    }

    private var vehicleBrandGetter: VehicleBrandGetter
    private var hasSelectedBrand: (Brand) -> Void

    @Published var error: LocalizedError?
    @Published var showAlert = false

    @Published var searchBrand: String = ""

    @Published var vehicleBrand: [Brand] = []
    @Published var brandSelected: Brand = Brand(id: "", name: "")

    var searchBrandResults: [Brand] {
        if searchBrand.isEmpty {
            return vehicleBrand
        } else {
            return vehicleBrand.filter { $0.name.hasPrefix(searchBrand.uppercased()) }
        }
    }

    @MainActor
    func getVehicleBrand() async {
        do {
            vehicleBrand = try await vehicleBrandGetter.getVehicleBrand()
            vehicleBrand = vehicleBrand.sorted { $0.name < $1.name }
        } catch (let error) {
            if let error = error as? APICallerError {
                setError(with: error)
            }
        }
    }

    func dismissSelector() {
        hasSelectedBrand(brandSelected)
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
}
