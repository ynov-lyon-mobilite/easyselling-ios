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
        NavigationView {
            VStack(alignment: .leading) {
                VStack {
                    Text("Icône d'application")
                        .fontWeight(.bold)
                        .font(.title3)
                    SelectAppIcon()
                }
                .background(Color.white)
                .cornerRadius(20)
                .padding(.bottom, 30)

                VStack {
                    Text("Thème d'application")
                        .fontWeight(.bold)
                        .font(.title3)
                    SelectAppIcon()
                }
                .background(Color.white)
                .cornerRadius(20)
            }
            .navigationTitle("Préférences")
            .frame(width: .infinity, height: .infinity)
            .padding(20)
            .background(Asset.Colors.currentBackground.swiftUIColor)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel())
    }
}
