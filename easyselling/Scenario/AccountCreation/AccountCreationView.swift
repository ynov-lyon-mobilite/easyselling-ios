//
//  AccountCreationView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 13/10/2021.
//

import SwiftUI

struct AccountCreationView: View {
    
    @ObservedObject var viewModel: AccountCreationViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            if viewModel.state == .loading {
                ProgressView()
            } else {
                
                TextField(L10n.SignUp.mail, text: $viewModel.email)
                    .padding(6)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
                    .textContentType(.emailAddress)
                
                VStack {
                    SecureField(L10n.SignUp.password, text: $viewModel.password)
                        .padding(6)
                        .background(Color.gray.opacity(0.5))
                        .cornerRadius(10)
                        .textContentType(.newPassword)
                    SecureField(L10n.SignUp.passwordConfirmation, text: $viewModel.passwordConfirmation)
                        .padding(6)
                        .background(Color.gray.opacity(0.5))
                        .cornerRadius(10)
                        .textContentType(.newPassword)
                    Text(viewModel.error?.errorDescription ?? "")
                        .foregroundColor(.red)
                        .font(.headline)
                        .opacity(viewModel.error != nil ? 1 : 0)
                    }
                
                Button(L10n.SignUp.createAccountButton) {
                    Task {
                        await viewModel.createAccount(email: viewModel.email, password: viewModel.password, passwordConfirmation: viewModel.passwordConfirmation)
                    }
                }
                .foregroundColor(Color.white)
                .padding()
                .background(Color.black)
                .cornerRadius(30)
                
            }
        }
        .padding(.horizontal, 50)
        .alert(isPresented: $viewModel.showAlert, content: {
            Alert(
                title: Text(viewModel.alert?.errorDescription ?? ""),
                dismissButton: Alert.Button.default(Text("Ok")))
        })
    }
}

struct AccountCreationView_Previews: PreviewProvider {
    static var previews: some View {
        AccountCreationView(viewModel: AccountCreationViewModel(verificator: DefaultInformationsVerificator()))
            .environment(\.locale, .init(identifier: "fr"))
    }
}
