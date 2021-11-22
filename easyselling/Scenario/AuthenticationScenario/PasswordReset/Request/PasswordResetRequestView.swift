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
                
                Button(L10n.PasswordReset.sendMailButton) {
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

struct PasswordResetRequestView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetRequestView(viewModel: PasswordResetRequestViewModel())
    }
}
