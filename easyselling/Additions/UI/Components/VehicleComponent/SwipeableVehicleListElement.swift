//
//  SwipeableVehicleListElement.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 30/03/2022.
//

import SwiftUI

struct SwipeableVehicleListElement: View {

    var vehicle: Vehicle
    var deleteAction: Action
    var updateAction: Action
    var shareAction: Action
    var showInvoices: Action

    var body: some View {
        HStack(alignment: .bottom) {
            VehicleListElement(vehicle: vehicle, action: showInvoices)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(action: { deleteAction() }, label: {
                Image(systemName: "trash.fill")
                    .font(.title2)
            })
            .tint(Color.red.opacity(0.5))

            Button(action: { updateAction() }, label: {
                Image(systemName: "pencil")
                    .font(.title2)
            })
            .tint(Asset.Colors.secondary.swiftUIColor.opacity(0.5))
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button(action: { shareAction() }, label: {
                Image(systemName: "square.and.arrow.up")
                    .font(.title2)
            })
            .tint(Color.green.opacity(0.5))
        }
    }
}

struct SwipeableVehicleListElement_Previews: PreviewProvider {
    static var previews: some View {
        SwipeableVehicleListElement(vehicle: Vehicle(id: "", brand: "Peugeot", model: "206", licence: "AA-222-aA", type: .car, year: "2022"),
                           deleteAction: {},
                           updateAction: {},
                           shareAction: {},
                           showInvoices: {})
            .previewLayout(.sizeThatFits)
            .background(Asset.Colors.backgroundColor.swiftUIColor)
    }
}
