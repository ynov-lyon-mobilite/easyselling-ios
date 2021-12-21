//
//  PrimaryButtonStyle.swift
//  easyselling
//
//  Created by Maxence on 07/12/2021.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    @ObservedObject private var themeManager: DefaultThemeManager = .shared
    private let color: Color?

    init(color: Color? = nil) {
        self.color = color
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .fillMaxWidth()
            .font(.body.bold())
            .background(color ?? themeManager.theme.primaryColor)
            .foregroundColor(.white)
            .cornerRadius(15)
    }
}

struct PrimaryButtonStyle_Peviews: PreviewProvider {
    static var previews: some View {
        Button(L10n.Button.forgottenPassword, action: {})
            .buttonStyle(PrimaryButtonStyle())
            .previewLayout(.sizeThatFits)

        Button(L10n.Button.forgottenPassword, action: {})
            .buttonStyle(PrimaryButtonStyle())
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
