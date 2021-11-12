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
        Text("Hello, World!")
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView(viewModel: PasswordResetViewModel())
    }
}
