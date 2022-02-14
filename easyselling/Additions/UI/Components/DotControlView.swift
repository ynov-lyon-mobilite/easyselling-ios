//
//  DotControlView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 05/02/2022.
//

import SwiftUI

struct DotControlView: View {

    let totalElements: Int
    let contentIndex: Int

    let basicWidth: CGFloat = 10
    let animationWidth: CGFloat = 30

    var body: some View {
        HStack {
            ForEach(0..<totalElements) { index in
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(index == contentIndex
                          ? Color.primaryEasyselling
                          : Color.onBackground.opacity(0.8))
                    .frame(width: index == contentIndex ?
                           animationWidth : basicWidth, height: 10)
                    .animation(.easeIn, value: index == contentIndex ? animationWidth: basicWidth)
            }
        }
    }
}

struct DotControlView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DotControlView(totalElements: 10, contentIndex: 4)
                .previewLayout(PreviewLayout.sizeThatFits)
            DotControlView(totalElements: 20, contentIndex: 4)
                .previewLayout(PreviewLayout.sizeThatFits)
        }
        .padding()
    }
}
