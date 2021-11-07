//
//  PasswordResetView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 04/11/2021.
//

import SwiftUI

struct PasswordResetView: View {
    
    @ObservedObject private var viewModel: PasswordResetViewModel
    
    init(viewModel: PasswordResetViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            TextField(L10n.SignUp.mail, text: $viewModel.email)
                .padding(6)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)
                .textContentType(.emailAddress)
            
            if viewModel.state == .loading {
                ProgressView()
            } else if viewModel.state == .requestSent {
                Text(viewModel.resetRequestSuccessfullySent)
            } else {
                Text(viewModel.error?.errorDescription ?? "")
                    .foregroundColor(.red)
                    .font(.headline)
                    .opacity(viewModel.error != nil ? 1 : 0)
                
                Button(L10n.SignUp.createAccountButton) {
                    Task {
                        await viewModel.requestPasswordReset()
                    }
                }
                .foregroundColor(Color.white)
                .padding()
                .background(Color.black)
                .cornerRadius(30)
            }
        }
        .padding(.horizontal)
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView(viewModel: PasswordResetViewModel())
    }
}
