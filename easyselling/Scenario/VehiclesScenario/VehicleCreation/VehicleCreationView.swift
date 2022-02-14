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
        VStack(spacing: 15) {
                Text("Mon type de véhicule")
                    .foregroundColor(Asset.Colors.primary.swiftUIColor)
                    .font(.title2)
                    .bold()

                Button(action: {}) {
                    Text("Une voiture")
                        .foregroundColor(Asset.Colors.primary.swiftUIColor)
                        .font(.headline)
                        .bold()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(25)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 0)

                Button(action: {}) {
                    Text("Une moto")
                        .foregroundColor(Asset.Colors.primary.swiftUIColor)
                        .font(.headline)
                        .bold()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(25)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 0)

                Button("Continuer", action: {})
                    .buttonStyle(PrimaryButtonStyle())

                DotControlView(totalElements: 4, contentIndex: 0)
            }
            .padding([.leading, .trailing, .bottom], 25)
            .padding(.top, 10)
            .background(Asset.Colors.whiteBackground.swiftUIColor)
    }
}

struct VehicleCreationView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleCreationView(viewModel: VehicleCreationViewModel(vehicleCreator: DefaultVehicleCreator(), vehicleVerificator: DefaultVehicleInformationsVerificator(), onFinish: {}))
            .previewLayout(PreviewLayout.sizeThatFits)
    }
}

//
//            Text(L10n.CreateVehicle.title)
//                .font(.title)
//                .fontWeight(.bold)
//
//            Divider()
//
//            TextField(L10n.CreateVehicle.brand, text: $viewModel.brand)
//                .padding(.top)
//
//            TextField(L10n.CreateVehicle.model, text: $viewModel.model)
//                .padding(.top)
//
//            TextField(L10n.CreateVehicle.license, text: $viewModel.license)
//                .padding(.top)
//
//            Text(L10n.CreateVehicle.Form.adviceForLicense)
//                .font(.system(size: 13))
//                .frame(maxWidth: .infinity, alignment: .leading)
//
//            HStack(alignment: .lastTextBaseline) {
//                Picker("Type", selection: $viewModel.type) {
//                    Text(L10n.Vehicles.car).tag(Vehicle.Category.car)
//                    Text(L10n.Vehicles.moto).tag(Vehicle.Category.moto)
//                }
//                Spacer(minLength: 50)
//                TextField(L10n.CreateVehicle.year, text: $viewModel.year)
//                    .padding(.top)
//                    .keyboardType(.numberPad)
//            }
//
//            Button(L10n.CreateVehicle.submit) {
//                Task {
//                    await viewModel.createVehicle()
//                }
//            }
//            .padding(.top)
//            Spacer()
