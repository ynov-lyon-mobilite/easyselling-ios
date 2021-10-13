//
//  VehicleCreationView.swift
//  easyselling
//
//  Created by Valentin Mont School on 13/10/2021.
//

import SwiftUI

struct VehicleCreationView: View {
    @State private var brand: String = ""
    @State private var model: String = ""
    @State private var immatriculation: String = ""
    @State private var age: String = ""
    @State private var type: String = ""
    
    var body: some View {
        VStack {
            VStack {
                Text("Marque Model")
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            Divider()
            
            TextField("Marque", text: $brand)
                .padding(.top)
            
            TextField("Modèle", text: $model)
                .padding(.top)
            
            TextField("Immatriculation", text: $immatriculation)
                .padding(.top)
            
            HStack(alignment: .lastTextBaseline) {
                Picker("Type", selection: $type) {
                    Text("Voiture").tag(VehicleType.car)
                    Text("Moto").tag(VehicleType.motorcycle)
                }
                Spacer(minLength: 50)
                TextField("Age", text: $age)
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
    }
    
    func createNewVehicle() {
        
    }
}

struct VehicleCreationView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleCreationView()
    }
}
