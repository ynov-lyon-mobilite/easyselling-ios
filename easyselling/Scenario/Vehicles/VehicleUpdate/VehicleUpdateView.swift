//
//  VehicleUpdateView.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 17/11/2021.
//

import SwiftUI

struct VehicleUpdateView: View {
    let viewModel: VehicleUpdateViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct VehicleUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleUpdateView(viewModel: VehicleUpdateViewModel(vehicule: Vehicle(id: "1", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1")))
    }
}
