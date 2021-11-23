//
//  VehicleUpdateView.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 18/11/2021.
//

import SwiftUI

struct VehicleUpdateView: View {
    
    @ObservedObject var viewModel: VehicleUpdateViewModel
    
    var body: some View {
        VStack {
            Button("Delete") {
                Task {
                    await viewModel.onFinish()
                }
            }
        }
    }
}

struct VehicleUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleUpdateView(viewModel: VehicleUpdateViewModel(vehicle: Vehicle(brand: "", model: "", license: "", type: .car, year: ""), onFinish: {}, vehicleVerificator: DefaultVehicleInformationsVerificator()))
    }
}
