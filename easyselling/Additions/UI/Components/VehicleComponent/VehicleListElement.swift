//
//  VehicleListElement.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 30/03/2022.
//

import SwiftUI

struct VehicleListElement: View {

    var vehicle: Vehicle
    var deleteAction: Action
    var updateAction: Action
    var shareAction: Action
    var showInvoices: Action

    var body: some View {
        HStack(alignment: .bottom) {
            Button(action: { showInvoices() }, label: {
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
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(action: { deleteAction() }, label: {
                Image(systemName: "trash.fill")
                    .font(.title2)
            })
            .tint(Color.red)

            Button(action: { updateAction() }, label: {
                Image(systemName: "pencil")
                    .font(.title2)
            })
            .tint(Asset.Colors.secondary.swiftUIColor)
            Button(L10n.Vehicles.shareButton) {
                shareAction()
            }.tint(Color.green)
        }
    }
}

struct VehicleListElement_Previews: PreviewProvider {
    static var previews: some View {
        VehicleListElement(vehicle: Vehicle(id: "", brand: "Peugeot", model: "206", licence: "AA-222-aA", type: .car, year: "2022"),
                           deleteAction: {},
                           updateAction: {},
                           shareAction: {},
                           showInvoices: {})
            .previewLayout(.sizeThatFits)
            .background(Asset.Colors.backgroundColor.swiftUIColor)
    }
}
