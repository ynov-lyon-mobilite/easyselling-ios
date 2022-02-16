//
//  ProfileView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 26/11/2021.
//

import SwiftUI

struct ProfileView: View {

    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        VStack(alignment: .leading) {
            TitleNavigationView(title: L10n.Profile.title)
            VStack(alignment: .leading) {
                ButtonList(title: L10n.Profile.explanations, icon: Asset.Icons.questionmark.image, color: Asset.Colors.secondary.swiftUIColor, action: {})
                ButtonList(title: L10n.Profile.informations, icon: Asset.Icons.info.image, color: Asset.Colors.secondary.swiftUIColor, action: {})
                ButtonList(title: L10n.Profile.settings, icon: Asset.Icons.settings.image, color: Asset.Colors.secondary.swiftUIColor, action: viewModel.navigatesToSettingsMenu)
                Spacer()
                ButtonList(title: L10n.Profile.logout, icon: Asset.Icons.logout.image, color: Color.red, action: viewModel.logout)
            }
        }
        .padding(.horizontal, 25)
        .background(Asset.Colors.currentBackground.swiftUIColor.ignoresSafeArea())
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel(onLogout: {}, isNavigatingToSettingsMenu: {}))
    }
}
