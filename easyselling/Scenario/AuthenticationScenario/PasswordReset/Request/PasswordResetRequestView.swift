//
//  PasswordResetView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 04/11/2021.
//

import SwiftUI

struct PasswordResetRequestView: View {

    @ObservedObject private var viewModel: PasswordResetRequestViewModel

    init(viewModel: PasswordResetRequestViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 40) {
            Image(Asset.PasswordRequest.mailBlue.name)
            VStack {
                TextField(L10n.SignUp.mail, text: $viewModel.email)
                    .padding(10)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
                    .textContentType(.emailAddress)

                if viewModel.state == .requestSent {
                    Text(viewModel.resetRequestSuccessfullySent)
                        .foregroundColor(Asset.Colors.secondary.swiftUIColor)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Button(action: { Task {
                await viewModel.requestPasswordReset()
            }}) {
                if viewModel.state == .requestSent {
                    Text(L10n.PasswordReset.understand)
                } else {
                    Text(L10n.PasswordReset.sendMailButton)
                }
            }
            .buttonStyle(PrimaryButtonStyle(isLoading: .constant(viewModel.state == .loading)))
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .padding(25)
        .ableToShowError(viewModel.error)
    }
}

struct PasswordResetRequestView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetRequestView(viewModel: PasswordResetRequestViewModel())
    }
}
