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

            TextField(viewModel.vehicle.brand, text: $viewModel.brand)
                .padding(.top)

            TextField(viewModel.vehicle.model, text: $viewModel.model)
                .padding(.top)

            TextField(viewModel.vehicle.license, text: $viewModel.license)
                .padding(.top)

            HStack(alignment: .lastTextBaseline) {
                Picker("Type", selection: $viewModel.type) {
                    Text(L10n.Vehicles.car).tag(Vehicle.Category.car)
                    Text(L10n.Vehicles.moto).tag(Vehicle.Category.moto)
                }
                Spacer(minLength: 50)
                TextField(viewModel.vehicle.year, text: $viewModel.year)
                    .padding(.top)
                    .keyboardType(.numberPad)
            }
                .padding()

                .alert(isPresented: $viewModel.showAlert, content: {
                    Alert(
                        title: Text(viewModel.alert)
                )})

            Button("Update Vehicle") {
                viewModel.updateVehicle()
            }

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
