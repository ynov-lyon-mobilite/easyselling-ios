//
//  SwiftUIView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 13/10/2021.
//

import SwiftUI

struct OnBoardingView: View {
    
   @ObservedObject var viewModel: OnBoardingViewModel

    init(viewModel: OnBoardingViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            
            Text(viewModel.feature?.title ?? "")
            
            Spacer()
            Button(action: viewModel.previousFeature) {
                Text("previous")
            }
            
            Button(action: viewModel.nextFeature) {
                Text("next")
            }
            
            Button(action: viewModel.skipFeatures) {
                Text("skip")
            }

        }
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
            OnBoardingView(viewModel: OnBoardingViewModel(features: [
                Feature(title: "Page One", image: "Lucas", text: "Lorem ipsum dolor sit amet. Ea nihil veritatis et labore molestias eum rerum excepturi"),
                Feature(title: "Page Two", image: "Lucas", text: "Lorem ipsum dolor sit amet. Ea nihil veritatis et labore molestias eum rerum excepturi"),
                Feature(title: "Page Three", image: "Lucas", text: "Lorem ipsum dolor sit amet. Ea nihil veritatis et labore molestias eum rerum excepturi")]))
    }
}
