//
//  Loader.swift
//  easyselling
//
//  Created by Corentin Laurencine on 09/03/2022.
//

import SwiftUI

struct Loader: View {

    @State var animateBox = false
    @State var animateRotation = false

    var body: some View {

        ZStack {
            Color.white
                .frame(width: 125, height: 125)
                .cornerRadius(15)
                .shadow(color: Color.primary.opacity(0.07), radius: 5, x: 5, y: 5)
                .shadow(color: Color.primary.opacity(0.07), radius: 5, x: -5, y: -5)
            Image(Asset.ThemeImages.Orange.logoOrange)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 65, height: 65)
                .rotation3DEffect(.init(degrees: animateRotation ? 360 : 0), axis: (x: 1, y: 0.0, z: 0.0))
        }
        .onAppear {
            doAnimation()
        }

    }

    func doAnimation() {
        withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: false)) {
            animateRotation.toggle()
        }
    }
}

struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        Loader()
    }
}
