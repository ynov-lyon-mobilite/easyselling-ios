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
        VStack(spacing: 30) {
            HStack {
                Button(action: { viewModel.onFinish() }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .foregroundColor(.onBackground)
                        .frame(width: 15, height: 15)
                        .padding()
                }
            }
            .fillMaxWidth(alignment: .trailing)
            .padding(.horizontal)

            TabView(selection: $viewModel.currentFeatureIndex) {
                ForEach(viewModel.features) { feature in
                    VStack(spacing: 45) {
                        Image(feature.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)

                        Spacer()

                        Text(feature.title)
                            .font(.largeTitle)
                            .fillMaxWidth(alignment: .leading)

                        Text(feature.text)
                            .font(.body)
                            .fillMaxWidth(alignment: .leading)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 30)
                }
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

            HStack {
                ForEach(viewModel.features) { feature in
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(feature == viewModel.currentFeature
                              ? Color.primaryEasyselling
                              : Color.onBackground.opacity(0.8))
                        .frame(width: feature == viewModel.currentFeature ?
                               animationWidth : basicWidth, height: 10)
                        .animation(.easeIn, value: feature == viewModel.currentFeature ? animationWidth: basicWidth)
                }
            }

            Spacer()

            HStack {
                Button(L10n.OnBoarding.Button.previous) {
                    withAnimation {
                        viewModel.previousFeature()
                    }
                }
                .opacity(viewModel.isShowingPreviousButton ? 1 : 0)
                .disabled(!viewModel.isShowingPreviousButton)
                .foregroundColor(Asset.Colors.secondary.swiftUIColor)
                .font(.body.bold())

                Spacer()

                Button(L10n.OnBoarding.Button.next) {
                    withAnimation {
                        viewModel.nextFeature()
                    }
                }
                .foregroundColor(viewModel.isLastFeature ? .white : Color.secondaryEasyselling)
                .font(.body.bold())
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(viewModel.isLastFeature ? Asset.Colors.secondary.swiftUIColor : nil)
                .cornerRadius(100)
            }
            .padding(.horizontal, 10)
            .padding(.bottom)
        }
        .navigationBarHidden(true)
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView(viewModel: OnBoardingViewModel(features: [
            Feature(title: L10n.OnBoarding.Features._1.title, image: Asset.OnBoarding.first.name, text: L10n.OnBoarding.Features._1.label),
            Feature(title: L10n.OnBoarding.Features._2.title, image: Asset.OnBoarding.second.name, text: L10n.OnBoarding.Features._2.label),
            Feature(title: L10n.OnBoarding.Features._3.title, image: Asset.OnBoarding.third.name, text: L10n.OnBoarding.Features._3.label)
        ], onFinish: {}))
    }
}
