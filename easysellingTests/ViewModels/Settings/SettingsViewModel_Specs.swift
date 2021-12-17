//
//  SettingsViewModel_Specs.swift
//  easysellingTests
//
//  Created by Maxence on 16/12/2021.
//

import XCTest
@testable import easyselling

class SettingsViewModel_Specs: XCTestCase {
    func test_Setups_default_color() {
        givenViewModel()
        thenTheme(is: .orange)
        setTheme(theme: .blue)
        thenTheme(is: .blue)
    }

    private func givenViewModel()  {
        viewModel = SettingsViewModel(themeManager: FakeThemeManager())
    }

    private func setTheme(theme: Themes) {
        viewModel.setTheme(theme)
    }


    private func thenTheme(is expected: Themes) {
        XCTAssertEqual(expected.rawValue, viewModel.themeManager.selectedTheme.rawValue)
    }

    private var viewModel: SettingsViewModel!
}

final class FakeThemeManager: ThemeManager {
    var selectedTheme: Themes = .orange

    var theme: AppTheme {
        selectedTheme.theme
    }

    func setTheme(_ theme: Themes) {
        self.theme = theme
    }
}

class ThemeManagerDecorator: ThemeManager {
    private let decorated: ThemeManager

    var selectedTheme: Themes = .orange

    var theme: AppTheme {
        selectedTheme.theme
    }

    func setTheme(_ theme: Themes) {
        decorated.setTheme(theme)
    }

    init(_ decorated: ThemeManager) {
        self.decorated = decorated
    }
}

final class SpyThemeManager: ThemeManagerDecorator {

}

extension ThemeManager {
    func spied() -> ThemeManager {
        ThemeManagerDecorator(self)
    }
}
