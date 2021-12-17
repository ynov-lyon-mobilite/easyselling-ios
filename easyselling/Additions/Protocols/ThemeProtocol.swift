//
//  ThemeProtocol.swift
//  easyselling
//
//  Created by Maxence on 16/12/2021.
//

import Foundation
import SwiftUI

protocol AppTheme {
    //  Colors
    var primaryColor: Color { get }
    var secondaryColor: Color { get }
    var onBackground: Color { get }
    var background: Color { get }

    //  Images
    var logo: ImageAsset { get }
}

struct OrangeTheme: AppTheme {
    var primaryColor: Color = Asset.Colors.primary.swiftUIColor
    var secondaryColor: Color = Asset.Colors.secondary.swiftUIColor
    var onBackground: Color = Asset.Colors.onBackground.swiftUIColor
    var background: Color = Asset.Colors.background.swiftUIColor

    var logo: ImageAsset = Asset.ThemeImages.Orange.logoOrange
}

struct BlueTheme: AppTheme {
    var primaryColor: Color = Asset.Colors.secondary.swiftUIColor
    var secondaryColor: Color = Asset.Colors.primary.swiftUIColor
    var onBackground: Color = Asset.Colors.onBackground.swiftUIColor
    var background: Color = Asset.Colors.background.swiftUIColor

    var logo: ImageAsset = Asset.ThemeImages.Blue.logoBlue
}

 class DefaultThemeManager: ThemeManager {
    @AppStorage("APP_THEME") var selectedTheme: Themes = .orange
    var theme: AppTheme {
        selectedTheme.theme
    }

    static let shared = DefaultThemeManager()

    func setTheme(_ theme: Themes) {
        withAnimation { [weak self] in
            self?.selectedTheme = theme
        }
    }
}

enum Themes: Int {
    case orange = 0
    case blue = 1

    var theme: AppTheme {
        switch self {
        case .orange: return OrangeTheme()
        case .blue: return BlueTheme()
        }
    }
}

protocol ThemeManager: ObservableObject {
    var selectedTheme: Themes { get set }
    var theme: AppTheme { get }

    func setTheme(_ theme: Themes)
}
