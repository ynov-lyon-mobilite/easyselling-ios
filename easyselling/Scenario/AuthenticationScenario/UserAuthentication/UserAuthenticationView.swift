//
//  UserAuthenticationView.swift
//  easyselling
//
//  Created by Maxence on 27/10/2021.
//

import SwiftUI

struct UserAuthenticationView: View {
    @ObservedObject private var viewModel: UserAuthenticationViewModel
    
    init(viewModel: UserAuthenticationViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            Circle()
            Spacer()
            VStack {
                TextField(L10n.SignUp.mail, text: $viewModel.email)
                    .padding(10)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
                    .textContentType(.emailAddress)

                SecureField(L10n.SignUp.password, text: $viewModel.password)
                    .padding(10)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
                    .textContentType(.password)
                
                Text(viewModel.error?.errorDescription ?? "")
                    .foregroundColor(.red)
                    .font(.headline)
                    .opacity(viewModel.error != nil ? 1 : 0)
                
                Button(L10n.Button.forgottenPassword) {
                    viewModel.navigateToPasswordReset()
                }
            }
            Spacer()
            Button(L10n.UserAuthentication.Button.login) {
                Task {
                    await viewModel.login()
                }
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(Color.black)
            .padding(.vertical, 8)
            .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.gray.opacity(0.5),
                                lineWidth: 4)
                )
            .padding(.horizontal)
            
            Spacer()
            
            Button(L10n.UserAuthentication.Button.register) {
                viewModel.navigateToAccountCreation()
            }
        }
        .padding()
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(viewModel.alert?.errorDescription ?? ""),
                dismissButton: Alert.Button.default(Text(L10n.Button.ok)))
        }
    }
}

struct UserAuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = UserAuthenticationViewModel(navigateToAccountCreation: {}, navigateToPasswordReset: {}, onUserLogged: {})
        UserAuthenticationView(viewModel: viewModel)
    }
}
