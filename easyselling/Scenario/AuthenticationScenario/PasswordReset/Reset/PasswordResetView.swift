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
        VStack {
            SecureField(L10n.SignUp.password, text: $viewModel.newPassword)
                .padding(6)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)
                .textContentType(.emailAddress)
            
            SecureField(L10n.SignUp.passwordConfirmation, text: $viewModel.newPasswordConfirmation)
                .padding(6)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)
                .textContentType(.emailAddress)
            
            Text(viewModel.error?.errorDescription ?? "")
                .foregroundColor(.red)
                .font(.headline)
                .opacity(viewModel.error != nil ? 1 : 0)
            
            Button(L10n.PasswordReset.resetPasswordButton) {
                Task {
                    await viewModel.resetPassword()
                }
            }
            .foregroundColor(Color.white)
            .padding()
            .background(Color.black)
            .cornerRadius(30)
        }
        .padding(.horizontal)
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView(viewModel: PasswordResetViewModel(token: "", onPasswordReset: {}))
    }
}
