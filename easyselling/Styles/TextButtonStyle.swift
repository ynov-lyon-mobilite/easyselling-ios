//
//  TextButtonStyle.swift
//  easyselling
//
//  Created by Maxence on 07/12/2021.
//

import SwiftUI

struct TextButtonStyle: ButtonStyle {
    @ObservedObject private var themeManager: ThemeManager = .shared
    private let color: Color?

    init(color: Color? = nil) {
        self.color = color
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.bold())
            .foregroundColor(color ?? themeManager.theme.primaryColor)
    }
}

struct TextButtonStyle_Peviews: PreviewProvider {
    static var previews: some View {
        Button(L10n.Button.forgottenPassword, action: {})
            .buttonStyle(TextButtonStyle())
            .previewLayout(.sizeThatFits)

        Button(L10n.Button.forgottenPassword, action: {})
            .buttonStyle(TextButtonStyle())
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
