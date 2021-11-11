//
//  MyVehiclesViewModel.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 25/10/2021.
//

import Foundation
import UIKit

class MyVehiclesViewModel: ObservableObject {
    
    init(vehiclesGetter: VehiclesGetter = DefaultVehiclesGetter(),
         isOpenningVehicleCreation: @escaping Action) {
        self.vehiclesGetter = vehiclesGetter
        self.isOpenningVehicleCreation = isOpenningVehicleCreation
    }
    
    private var vehiclesGetter: VehiclesGetter
    private var isOpenningVehicleCreation: Action
    @Published var isLoading: Bool = true
    @Published var vehicles: [Vehicle] = []
    @Published var alert: APICallerError?
    @Published var isError: Bool = false
 
    func openVehicleCreation() {
        self.isOpenningVehicleCreation()
    }
    
    @MainActor func getVehicles() async {
        do {
            vehicles = try await vehiclesGetter.getVehicles()
        } catch (let error) {
            if let error = error as? APICallerError {
                isError = true
                self.alert = error
            } else {
                self.alert = nil
            }
        }
        
        isLoading = false
    }
}
