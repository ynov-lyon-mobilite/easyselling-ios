//
//  VehicleFormTextField.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 15/02/2022.
//

import SwiftUI

struct VehicleFormTextField: View {

    @Binding var text: String
    var placeholder: String

    var body: some View {
        TextField("", text: $text)
            .placeholder(when: text.isEmpty) {
                Text(placeholder)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(Asset.Colors.primary.swiftUIColor)
                    .font(.headline)
            }
            .font(.headline)
            .multilineTextAlignment(.center)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(25)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 0)
    }
}

//struct VehicleFormTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        VehicleFormTextField(text: text)
//    }
//}
