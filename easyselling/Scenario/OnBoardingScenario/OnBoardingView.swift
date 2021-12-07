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

    let basicWidth: CGFloat = 10
    let animationWidth: CGFloat = 30

    var body: some View {
        VStack {
            TabView(selection: $viewModel.currentFeatureIndex) {
                ForEach(0..<viewModel.features.count) { _ in
                    VStack {
                        Image(systemName: viewModel.feature.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.bottom, 75)

                        Text(viewModel.feature.title)
                            .font(.largeTitle)
                            .padding(.bottom, 30)

                        Text(viewModel.feature.text)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .frame(width: 250)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

            HStack {
                ForEach(0..<viewModel.features.count) { index in
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(index == viewModel.currentFeatureIndex
                              ? Asset.Colors.onBoardingDotActive.swiftUIColor
                              : Asset.Colors.onBoardingDotInactive.swiftUIColor)
                        .frame(width: index == viewModel.currentFeatureIndex ?
                               animationWidth : basicWidth, height: 10)
                        .animation(.easeIn, value: index == viewModel.currentFeatureIndex ? animationWidth: basicWidth)
                }
            }
            .padding(25)
            Spacer()
            HStack {
                Button("Previous") {
                    withAnimation {
                        viewModel.previousFeature()
                    }
                }
                .opacity(viewModel.isShowingPreviousButton ? 1 : 0)
                .disabled(!viewModel.isShowingPreviousButton)

                Spacer()

                Button("Skip") {
                    viewModel.skipFeatures()
                }
                .opacity(viewModel.isShowingSkipButton ? 1 : 0)
                .disabled(!viewModel.isShowingSkipButton)

                Spacer()

                Button("Next") {
                    withAnimation {
                        viewModel.nextFeature()
                    }
                }
                .padding([.trailing, .leading], 20)
                .padding([.top, .bottom], 10)
                .background(viewModel.currentFeatureIndex == viewModel.features.count-1 ? Color.red : nil)
                .cornerRadius(100)
                .foregroundColor(viewModel.currentFeatureIndex == viewModel.features.count-1 ? Color.white : Color.blue)
            }
            .padding([.leading, .trailing], 10)
        }
        .padding(.bottom)
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView(viewModel: OnBoardingViewModel(features: [
            Feature(title: "Page One", image: "pencil", text: "1 - Lorem ipsum dolor sit amet. Ea nihil veritatis et labore molestias eum rerum excepturi"),
            Feature(title: "Page Two", image: "scribble", text: "2 - Lorem ipsum dolor sit amet. Ea nihil veritatis et labore molestias eum rerum excepturi"),
            Feature(title: "Page Three", image: "trash", text: "3 - Lorem ipsum dolor sit amet. Ea nihil veritatis et labore molestias eum rerum excepturi")], onFinish: {}))
    }
}
