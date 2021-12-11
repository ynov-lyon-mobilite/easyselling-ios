//
//  PasswordResetView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 12/11/2021.
//

import SwiftUI

struct PasswordResetView: View {

    @ObservedObject var viewModel: PasswordResetViewModel

    var body: some View {
        VStack(spacing: 40) {
            Image(Asset.PasswordReset.passwordResetBlue.name)
            VStack {
                SecureField(L10n.SignUp.password, text: $viewModel.newPassword)
                    .padding(10)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
                    .textContentType(.emailAddress)

                SecureField(L10n.SignUp.passwordConfirmation, text: $viewModel.newPasswordConfirmation)
                    .padding(10)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
                    .textContentType(.emailAddress)

                if viewModel.state == .resetSuccessfull {
                    Text(L10n.PasswordReset.resetSuccessfully)
                        .foregroundColor(Asset.Colors.secondary.swiftUIColor)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Text(viewModel.error?.errorDescription ?? "")
                    .foregroundColor(.red)
                    .font(.headline)
                    .opacity(viewModel.error != nil ? 1 : 0)
            }

            Button(action: {
                Task {
                await viewModel.resetPassword()
                }}) {
                    if viewModel.state == .resetSuccessfull {
                        Text(L10n.UserAuthentication.Button.login)
                    } else {
                        Text(L10n.PasswordReset.resetPasswordButton)
                    }
            }
            .buttonStyle(PrimaryButtonStyle())
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .padding(25)
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView(viewModel: PasswordResetViewModel(token: "", onPasswordReset: {}))
    }
}
