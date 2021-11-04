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
        Text("Hello, World!")
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView(viewModel: PasswordResetViewModel())
    }
}
