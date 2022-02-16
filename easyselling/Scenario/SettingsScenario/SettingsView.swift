//
//  SettingsView.swift
//  easyselling
//
//  Created by Lucas Barthélémy on 15/12/2021.
//

import Foundation
import SwiftUI

struct SettingsView: View {

    @ObservedObject var viewModel: SettingsViewModel

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading) {
            TitleNavigationView(title: L10n.Profile.settings)
            VStack {
                Text(L10n.Settings.icons)
                    .fontWeight(.bold)
                    .font(.title3)
                    .padding(.top, 10)
                SelectAppIcon()
            }
            .background(Color.white)
            .cornerRadius(20)
            .padding(.bottom, 30)

            VStack {
                Text(L10n.Settings.theme)
                    .fontWeight(.bold)
                    .font(.title3)
                    .padding(.top, 10)
                SelectAppIcon()
            }
            .background(Color.white)
            .cornerRadius(20)
            Spacer()
        }
        .padding(.horizontal, 25)
        .background(Asset.Colors.currentBackground.swiftUIColor.ignoresSafeArea())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel())
    }
}
