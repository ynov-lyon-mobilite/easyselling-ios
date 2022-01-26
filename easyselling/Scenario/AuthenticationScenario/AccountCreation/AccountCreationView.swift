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
        ImagedBackground {
            ScrollView(showsIndicators: false) {
                accountCreationView
            }
            .ableToShowError(viewModel.error?.errorDescription ?? "", when: viewModel.error == nil ? false : true)
        }
    }

    private var accountCreationView: some View {
        VStack(spacing: 30) {
            Image(Asset.ThemeImages.Orange.logoOrange)
                    .resizable()
                    .padding()
                    .frame(width: 230, height: 230)

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
                        .textContentType(.newPassword)
                    SecureField(L10n.SignUp.passwordConfirmation, text: $viewModel.passwordConfirmation)
                        .padding(10)
                        .background(Color.gray.opacity(0.5))
                        .cornerRadius(10)
                        .textContentType(.newPassword)
                    }

                Spacer()

                Button(L10n.SignUp.createAccountButton) {
                    Task {
                        await viewModel.createAccount()
                    }
                }
                .buttonStyle(PrimaryButtonStyle(isLoading: .constant(viewModel.state == .loading)))
            }
        .padding(25)
        .fillMaxHeight()
        .alert(isPresented: $viewModel.showAlert, content: {
            Alert(
                title: Text(viewModel.alert?.errorDescription ?? ""),
                dismissButton: Alert.Button.default(Text(L10n.Button.ok)))
        })
    }
}

struct AccountCreationView_Previews: PreviewProvider {
    static var previews: some View {
        AccountCreationView(viewModel: AccountCreationViewModel(preparator: DefaultCredentialsPreparator(), onAccountCreated: {}))
            .environment(\.locale, .init(identifier: "fr"))
    }
}
