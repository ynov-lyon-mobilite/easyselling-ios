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
        NavigationView {
            VStack(alignment: .leading) {
                ButtonList(title: "Explications", icon: Asset.Icons.questionmark.image, color: Color.blue)
                ButtonList(title: "Informations", icon: Asset.Icons.info.image, color: Color.blue)
                ButtonList(title: "Préférences", icon: Asset.Icons.settings.image, color: Color.blue)
                Spacer()
                Button(action: viewModel.logout) {
                    ButtonList(title: "Se déconnecter", icon: Asset.Icons.logout.image, color: Color.red)
                }
            }
            .navigationTitle("Mon profil")
            .padding(15)
            .background(Asset.Colors.currentBackground.swiftUIColor)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel(onLogout: {}))
    }
}

struct ButtonList: View {
    var title: String
    var icon: UIImage
    var color: Color

    var body: some View {
        HStack {
            Image(uiImage: self.icon)
                .padding(10)
                .background(Circle().foregroundColor(self.color))
                .padding(.leading, 10)
            Text(self.title)
                .fontWeight(.bold)
                .font(.title2)
                .padding(.vertical, 20)
                .padding(.leading, 10)
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(20)
        .padding(10)
    }
}
