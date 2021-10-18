//
//  UserAuthenticationView.swift
//  easyselling
//
//  Created by Maxence on 15/10/2021.
//

import SwiftUI

struct UserAuthenticationView: View {
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack {
            TextField(L10n.SignUp.mail, text: $email)
                .padding(6)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)
                .textContentType(.emailAddress)
            
            SecureField(L10n.SignUp.password, text: $password)
                .padding(6)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)
                .textContentType(.password)
        }
    }
}

struct UserAuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        UserAuthenticationView()
    }
}
