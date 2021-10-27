//
//  MyVehiclesViewModel.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 25/10/2021.
//

import Foundation

class MyVehiclesViewModel {
    
    init(isOpenningVehicleCreation: @escaping Action) {
        self.isOpenningVehicleCreation = isOpenningVehicleCreation
    }
    
    private var isOpenningVehicleCreation: Action
 
    func openVehicleCreation() {
        self.isOpenningVehicleCreation()
    }
}
