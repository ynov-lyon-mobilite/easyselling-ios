//
//  LaunchScreenView.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 20/04/2022.
//

import SwiftUI

struct LaunchScreenView: View {
    let onFinish: Action
    @State var width: CGFloat = 300
    let timer: Double = 2.0
    @State var isFinish = false
    var body: some View {
        VStack(alignment: .center) {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: width)
                .clipped()
        }
        .onAppear {
            startLaunchScreen()
        }
    }

    func startLaunchScreen() {
        withAnimation(.easeInOut(duration: timer)) {
            width = 400
        }
        Timer.scheduledTimer(withTimeInterval: timer, repeats: false, block: { _ in
            self.onFinish()
        })
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView(onFinish: {})
    }
}
