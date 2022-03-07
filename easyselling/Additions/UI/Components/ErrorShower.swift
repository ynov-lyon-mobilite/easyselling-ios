//
//  SwiftUIView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 16/12/2021.
//

import SwiftUI

struct ErrorShower: ViewModifier {
    @Namespace private var animation
    var error: Error?

    func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                if isShowingError {
                    VStack {
                        Text(error)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(25)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(30)
                    .padding(.top, 100)
                    .transition(.move(edge: .top))
                }
                Spacer()
            }
            .padding(.horizontal, 25)

        }
        .ignoresSafeArea()
    }
}
