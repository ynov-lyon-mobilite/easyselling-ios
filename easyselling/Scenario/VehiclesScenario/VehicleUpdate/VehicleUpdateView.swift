//
//  VehicleUpdateView.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 18/11/2021.
//

import SwiftUI

struct VehicleUpdateView: View {
    
    var viewModel: VehicleUpdateViewModel
    
    var body: some View {
        Text(viewModel.vehicle.id)
    }
}

struct VehicleUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleUpdateView(viewModel: VehicleUpdateViewModel(vehicle: Vehicle(brand: "", model: "", license: "", type: .car, year: "")))
    }
}
