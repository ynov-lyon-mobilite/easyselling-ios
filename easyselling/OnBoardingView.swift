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
            
            TabView(selection: $viewModel.currentFeatureIndex) {
                ForEach(0..<viewModel.features.count) { index in
                    VStack {
                        Image(systemName: viewModel.features[index].image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                        Text(viewModel.features[index].title)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            Spacer()
            HStack {
                Button("Previous") {
                    withAnimation {
                        viewModel.previousFeature()
                    }
                }
                .opacity(viewModel.isShowingPreviousButton ? 1 : 0)
                .disabled(!viewModel.isShowingPreviousButton)
                .frame(maxWidth: .infinity)
                .background(Color.yellow)
                
                Spacer()
                Button(action: viewModel.skipFeatures) {
                    withAnimation {
                        Text("skip")
                    }
                }
                .opacity(viewModel.isShowingSkipButton ? 1 : 0)
                .disabled(!viewModel.isShowingSkipButton)
                .frame(maxWidth: .infinity)
                .background(Color.red)
                
                Spacer()
                Button("next") {
                    withAnimation {
                        viewModel.nextFeature()
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color.green)
            }
        }
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView(viewModel: OnBoardingViewModel(features: [
            Feature(title: "Page One", image: "pencil", text: "Lorem ipsum dolor sit amet. Ea nihil veritatis et labore molestias eum rerum excepturi"),
            Feature(title: "Page Two", image: "scribble", text: "Lorem ipsum dolor sit amet. Ea nihil veritatis et labore molestias eum rerum excepturi"),
            Feature(title: "Page Three", image: "trash", text: "Lorem ipsum dolor sit amet. Ea nihil veritatis et labore molestias eum rerum excepturi")]))
    }
}
