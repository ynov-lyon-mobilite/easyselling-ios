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
        VStack {
            Button(action: viewModel.logout) {
                Text("LOGOUT")
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel(onLogout: {}))
    }
}
