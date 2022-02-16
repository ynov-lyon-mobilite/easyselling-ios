//
//  PrimaryButtonStyle.swift
//  easyselling
//
//  Created by Maxence on 07/12/2021.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    private let color: Color
    @Binding var isLoading: Bool

    init(color: Color = Asset.Colors.primary.swiftUIColor,
         isLoading: Binding<Bool> = .constant(false)) {
        self.color = color
        self._isLoading = isLoading
    }

    func makeBody(configuration: Configuration) -> some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                configuration.label
            }
        }
        .padding()
        .fillMaxWidth()
        .font(.body.bold())
        .background(color)
        .foregroundColor(.white)
        .cornerRadius(25)
    }
}

struct PrimaryButtonStyle_Peviews: PreviewProvider {
    static var previews: some View {
        Button(L10n.Button.forgottenPassword, action: {})
            .buttonStyle(PrimaryButtonStyle())
            .previewLayout(.sizeThatFits)

        Button(L10n.Button.forgottenPassword, action: {})
            .buttonStyle(PrimaryButtonStyle(isLoading: .constant(true)))
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
