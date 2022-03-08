//
//  ImagedBackground.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 22/12/2021.
//

import SwiftUI

struct ImagedBackground<Content : View>: View {
    let content: Content

    init(@ViewBuilder contentBuilder: () -> Content) {
        self.content = contentBuilder()
    }

    var body: some View {
        ZStack {
            Color.backgroundColor
                .ignoresSafeArea()
            GeometryReader { proxy in
                let height = proxy.size.height * 1.13
                let spacingTop = (height - proxy.size.height) / 2
                let spacingLeft = (height - proxy.size.width) / 2

                Image(Asset.ThemeImages.Orange.logoOrange)
                    .resizable()
                    .frame(width: height, height: height)
                    .opacity(0.07)
                    .rotationEffect(.init(degrees: -30))
                    .padding(.top, -spacingTop)
                    .padding(.leading, -spacingLeft)
            }.ignoresSafeArea()

            content
        }
    }
}

struct ImagedBackground_Previews: PreviewProvider {
    static var previews: some View {
        ImagedBackground {
            VStack {

            }
        }
    }
}
