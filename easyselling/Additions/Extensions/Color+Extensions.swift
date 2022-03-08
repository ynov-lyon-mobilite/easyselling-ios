//
//  Color+Extensions.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 03/11/2021.
//

import SwiftUI

extension ColorAsset {
    var swiftUIColor: SwiftUI.Color {
        return SwiftUI.Color(cgColor: color.cgColor)
    }
}

extension Color {
    static var primaryEasyselling = Asset.Colors.primary.swiftUIColor
    static var secondaryEasyselling = Asset.Colors.secondary.swiftUIColor
    static var onBackground = Asset.Colors.onBackground.swiftUIColor
    static var backgroundColor = Asset.Colors.backgroundColor.swiftUIColor
}
