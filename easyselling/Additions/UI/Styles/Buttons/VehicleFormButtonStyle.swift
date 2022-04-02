//
//  SwiftUIView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 15/02/2022.
//

import SwiftUI

struct VehicleFormButtonStyle: ButtonStyle {
    let isSelected: Bool

    init(isSelected: Bool) {
        self.isSelected = isSelected
    }

    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.label
                    .foregroundColor(Asset.Colors.primary.swiftUIColor)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isSelected ? Asset.Colors.secondary.swiftUIColor : Color.white)
                    .cornerRadius(25)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 0)
        }
    }
}

struct VehicleFormButtonStyle_Peviews: PreviewProvider {
    static var previews: some View {
        Button(L10n.Button.forgottenPassword, action: {})
            .buttonStyle(VehicleFormButtonStyle(isSelected: true))
            .previewLayout(.sizeThatFits)

        Button(L10n.Button.forgottenPassword, action: {})
            .buttonStyle(VehicleFormButtonStyle(isSelected: false))
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
