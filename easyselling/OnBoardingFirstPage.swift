//
//  SwiftUIView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 13/10/2021.
//

import SwiftUI

struct OnBoardingFirstPage: View {
    
    let viewModel: OnBoardingViewModel
    
    var body: some View {
        Button("Go to second page") {
            viewModel.navigateToScreen2 { }
        }
    }
}

struct OnBoardingFirstPage_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingFirstPage(viewModel: OnBoardingViewModel())
    }
}
