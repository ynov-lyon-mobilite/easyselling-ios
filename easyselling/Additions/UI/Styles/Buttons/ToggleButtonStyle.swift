//
//  ToggleButtonStyle.swift.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 16/02/2022.
//

import SwiftUI

struct ToggleButtonStyle: ButtonStyle {
    private let color: Color
    private let toggleColor: Color
    @Binding var isOn: Bool

    init(color: Color = Asset.Colors.primary.swiftUIColor,
         toggleColor: Color = Asset.Colors.secondary.swiftUIColor,
         isOn: Binding<Bool> = .constant(false)) {
        self.color = color
        self.toggleColor = toggleColor
        self._isOn = isOn
    }

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
                configuration.label
                    .padding()
                    .fillMaxWidth()
                    .font(.body.bold())
                    .background(isOn ? toggleColor : color)
                    .animation(.easeIn, value: isOn)
                    .foregroundColor(.white)
                    .cornerRadius(25)
        }
        .frame(maxHeight: 55)
    }
}
struct ToggleButtonStyle_swift_Previews: PreviewProvider {
    static var previews: some View {
        Button(L10n.Button.forgottenPassword, action: {})
            .buttonStyle(ToggleButtonStyle(isOn: .constant(true)))
            .previewLayout(.sizeThatFits)

        Button(L10n.Button.forgottenPassword, action: {})
            .buttonStyle(ToggleButtonStyle(isOn: .constant(false)))
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
