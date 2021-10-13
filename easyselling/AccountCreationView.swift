//
//  AccountCreationView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 13/10/2021.
//

import SwiftUI

struct AccountCreationView: View {
    
    let viewModel: AccountCreationViewModel
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct AccountCreationView_Previews: PreviewProvider {
    static var previews: some View {
        AccountCreationView(viewModel: AccountCreationViewModel())
    }
}
