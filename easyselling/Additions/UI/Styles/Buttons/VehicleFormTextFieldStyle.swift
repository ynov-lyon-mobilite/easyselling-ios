//
//  VehicleFormTextField.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 15/02/2022.
//

import SwiftUI

struct VehicleFormTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.headline)
            .foregroundColor(Asset.Colors.primary.swiftUIColor)
            .multilineTextAlignment(.center)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(25)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 0)
    }
}
