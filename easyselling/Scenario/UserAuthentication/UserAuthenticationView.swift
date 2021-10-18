//
//  UserAuthenticationView.swift
//  easyselling
//
//  Created by Maxence on 27/10/2021.
//

import SwiftUI

struct UserAuthenticationView: View {
    @ObservedObject private var viewModel = UserAuthenticationViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
            VStack {
                TextField(L10n.SignUp.mail, text: $viewModel.email)
                    .padding(6)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
                    .textContentType(.emailAddress)

                SecureField(L10n.SignUp.password, text: $viewModel.password)
                    .padding(6)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
                    .textContentType(.password)
            }
            
            Button(L10n.SignUp.createAccountButton) {
                Task {
                    await viewModel.login(mail: viewModel.email, password: viewModel.password)
                }
            }
            .foregroundColor(Color.white)
            .padding()
            .background(Color.black)
            .cornerRadius(30)
        }
        .padding(.horizontal, 50)
//        .alert(isPresented: $viewModel.showAlert, content: {
//            Alert(
//                title: Text(viewModel.alert?.errorDescription ?? ""),
//                dismissButton: Alert.Button.default(Text("Ok")))
//        })
    }
}

struct UserAuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        UserAuthenticationView()
    }
}
