//
//  VehicleCreationView.swift
//  easyselling
//
//  Created by Valentin Mont School on 13/10/2021.
//

import SwiftUI

struct VehicleCreationView: View {
   
    @ObservedObject var viewModel: VehicleCreationViewModel

    var body: some View {
        VStack {
            VStack {
                Text(L10n.CreateVehicle.title)
                    .font(.title)
                    .fontWeight(.bold)
            }

            Divider()

            TextField(L10n.CreateVehicle.brand, text: $viewModel.brand)
                .padding(.top)

            TextField(L10n.CreateVehicle.model, text: $viewModel.model)
                .padding(.top)

            TextField(L10n.CreateVehicle.license, text: $viewModel.license)
                .padding(.top)

            HStack(alignment: .lastTextBaseline) {
                Picker("Type", selection: $viewModel.type) {
                    Text(L10n.Vehicles.car).tag(VehicleInformations.Category.car)
                    Text(L10n.Vehicles.moto).tag(VehicleInformations.Category.car)
                }
                Spacer(minLength: 50)
                TextField(L10n.CreateVehicle.year, text: $viewModel.year)
                    .padding(.top)
                    .keyboardType(.numberPad)
            }

            VStack {
                Button(L10n.CreateVehicle.submit) {
                    Task {
                        await viewModel.createVehicle()
                    }
                }
            }
            .padding(.top)
            Spacer()
        }
        .padding()

        .alert(isPresented: $viewModel.showAlert, content: {
            Alert(
                title: Text(viewModel.alert)
        )})
    }
}

struct VehicleCreationView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleCreationView(viewModel: VehicleCreationViewModel(vehicleCreator: DefaultVehicleCreator(), vehicleVerificator: VehicleInformationsVerificator(), onFinish: {}))
    }
}
