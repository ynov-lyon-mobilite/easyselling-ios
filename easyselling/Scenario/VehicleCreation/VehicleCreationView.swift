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
            
            TextField("Immatriculation", text: $viewModel.immatriculation)
                .padding(.top)
            
            TextField("Numéro de licence", text: $viewModel.licenceNumber)
                .padding(.top)
            
            HStack(alignment: .lastTextBaseline) {
                Picker("Type", selection: $viewModel.type) {
                    Text("Voiture").tag(VehicleType.car)
                    Text("Moto").tag(VehicleType.motorcycle)
                }
                Spacer(minLength: 50)
                TextField("Année", text: $viewModel.year)
                    .padding(.top)
                    .keyboardType(.numberPad)
            }
            
            VStack {
                Button(action: createNewVehicle) {
                    Text("Button")
                }
            }
            .padding(.top)
            Spacer()
        }
        .padding()
        
        .alert(isPresented: $viewModel.showAlert, content: {
            Alert(
                title: Text(viewModel.alertText.errorDescription ?? "Error"),
                dismissButton: Alert.Button.default(Text("Ok")))
        })
    }
    
    func createNewVehicle() {
        // swiftlint:disable line_length
        viewModel.createVehicle(with: VehicleInformations(licenceNumber: viewModel.licenceNumber, brand: viewModel.brand, immatriculation: viewModel.immatriculation, type: viewModel.type, year: Int(viewModel.year) ?? 0, model: viewModel.model))
        // swiftlint:enable line_length
    }
}

struct VehicleCreationView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleCreationView(viewModel: VehicleCreationViewModel())
    }
}
