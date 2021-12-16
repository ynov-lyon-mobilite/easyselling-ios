//
//  SwiftUIView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 16/12/2021.
//

import SwiftUI

struct ErrorShower: ViewModifier {
    var error: String
    var isShowingError: Bool

    func body(content: Content) -> some View {
            ZStack {
                content
                if isShowingError == true {
                    VStack {
                        Text(error)
                            .font(.headline)
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 30)
                                            .fill(Asset.Colors.errorBackground.swiftUIColor))
                        Spacer()
                    }
                    .padding(.top)
                    .padding(.horizontal, 25)
                    .transition(.move(edge: .top))
                    .animation(.spring())
                }
            }
        }
}
