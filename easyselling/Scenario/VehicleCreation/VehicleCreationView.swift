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
                Text("Marque Model")
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            Divider()
            
            TextField("Marque", text: $viewModel.brand)
                .padding(.top)
            
            TextField("Modèle", text: $viewModel.model)
                .padding(.top)
            
            TextField("Numéro de licence", text: $viewModel.license)
                .padding(.top)
            
            HStack(alignment: .lastTextBaseline) {
                Picker("Type", selection: $viewModel.type) {
                    Text("Voiture").tag(VehicleType.carType)
                    Text("Moto").tag(VehicleType.motoType)
                }
                Spacer(minLength: 50)
                TextField("Année", text: $viewModel.year)
                    .padding(.top)
                    .keyboardType(.numberPad)
            }
            
            VStack {
                Button("Button") {
                    Task {
                        await createNewVehicle()
                    }
                }
            }
            .padding(.top)
            Spacer()
        }
        .padding()
        
        .alert(isPresented: $viewModel.showAlert, content: {
            Alert(
                title: Text(viewModel.alertText),
                dismissButton: Alert.Button.default(Text("Ok")))
        })
    }
    
    func createNewVehicle() async {
        // swiftlint:disable line_length
        await viewModel.createVehicle(with: VehicleInformations(license: viewModel.license, brand: viewModel.brand, type: viewModel.type.rawValue, year: viewModel.year, model: viewModel.model))
        // swiftlint:enable line_length
    }
}

struct VehicleCreationView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleCreationView(viewModel: VehicleCreationViewModel())
    }
}
