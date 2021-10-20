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
            Image(self.viewModel.features[self.viewModel.currentFeatureIndex].image)
                .frame(width: 50, height: 50)
            Text(self.viewModel.features[self.viewModel.currentFeatureIndex].title)
            HStack {
                if(!(self.viewModel.currentFeatureIndex == 0)) {
                    Button(action: previousPage) {
                        Text("Previous Page")
                    }
                }
                if(!(self.viewModel.currentFeatureIndex == self.viewModel.features.count - 1)) {
                    Button(action: nextPage) {
                        Text("Next Page")
                    }
                }
            }
        }
    }
    
    func nextPage() {
        print("Click on next button")
        self.viewModel.nextFeature()
        print("Page : " + String(self.viewModel.currentFeatureIndex + 1))
    }
    
    func previousPage() {
        print("Click on previous button")
        self.viewModel.previousFeature()
        print("Page : " + String(self.viewModel.currentFeatureIndex + 1))
    }
}

struct OnBoardingPage_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView(viewModel: OnBoardingViewModel(features: [
            Feature(title: "Page One", image: "Lucas"),
            Feature(title: "Page Two", image: "Bafabière"),
            Feature(title: "Page Three", image: "OhYeah")]))
    }
}
