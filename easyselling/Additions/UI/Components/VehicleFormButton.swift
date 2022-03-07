//
//  SwiftUIView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 15/02/2022.
//

import SwiftUI

struct VehicleFormButton: View {

    let action: Action
    let title: String
    let isSelected: Bool

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(Asset.Colors.primary.swiftUIColor)
                .font(.headline)
                .bold()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(isSelected ? Asset.Colors.secondary.swiftUIColor : Color.white)
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 0)
    }
}

struct VehicleFormButton_Previews: PreviewProvider {
    static var previews: some View {
        VehicleFormButton(action: {}, title: "Ma voiture", isSelected: true)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
