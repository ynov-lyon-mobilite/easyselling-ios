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
        ImagedBackground {
            ScrollView(.vertical, showsIndicators: false) {
                loginView
            }
            .ableToShowError(viewModel.error)
        }
    }

    private var loginView: some View {
        VStack(spacing: 30) {
            Spacer()

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
                    .disableAutocorrection(true)

                SecureField(L10n.SignUp.password, text: $viewModel.password)
                    .padding(10)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
                    .textContentType(.password)
                    .disableAutocorrection(true)

                    Button(L10n.Button.forgottenPassword) {
                        viewModel.navigateToPasswordReset()
                    }
                    .buttonStyle(TextButtonStyle())
                    .fillMaxWidth(alignment: .trailing)
            }
            Spacer()
            Button(L10n.UserAuthentication.Button.login) {
                Task {
                    await viewModel.login()
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .frame(maxWidth: .infinity)

            HStack {
                Text(L10n.UserAuthentication.Register.label)

                Button(L10n.UserAuthentication.Register.button) {
                    viewModel.navigateToAccountCreation()
                }
                .buttonStyle(TextButtonStyle())
                .padding([.leading, .top, .bottom])
            }
        }
        .navigationBarHidden(true)
        .padding(25)
        .fillMaxHeight()
    }
}

struct UserAuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = UserAuthenticationViewModel(navigateToAccountCreation: {}, navigateToPasswordReset: {}, onUserLogged: {})

        UserAuthenticationView(viewModel: viewModel)
        UserAuthenticationView(viewModel: viewModel)
            .preferredColorScheme(.dark)
    }
}
