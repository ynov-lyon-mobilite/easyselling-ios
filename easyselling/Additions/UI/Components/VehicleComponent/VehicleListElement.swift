//
//  VehicleListElement.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 19/04/2022.
//

import SwiftUI

struct VehicleListElement: View {

    var vehicle: Vehicle
    var action: Action

    var body: some View {
        Button(action: { action() }, label: {
            HStack {
                Image(uiImage: vehicle.image)
                    .padding(15)
                    .background(Circle().foregroundColor(vehicle.imageColor))
                VStack(alignment: .leading) {
                    Text("\(vehicle.brand) \(vehicle.model)")
                        .fontWeight(.bold)
                        .font(.title3)
                        .foregroundColor(vehicle.imageColor)
                    Text(vehicle.licence)
                        .font(.body)
                }
                Spacer()
                Text(vehicle.year)
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(Asset.Colors.secondaryBackground.swiftUIColor)
            .cornerRadius(22)
            .padding(.vertical)
        })
    }
}

struct VehicleListElement_Previews: PreviewProvider {
    static var previews: some View {
        VehicleListElement(vehicle: Vehicle(id: "", brand: "Peugeot", model: "206", licence: "AA-222-aA", type: .car, year: "2022"), action: {})
    }
}
