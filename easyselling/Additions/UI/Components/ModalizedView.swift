//
//  ModalizedView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 01/02/2022.
//

import Foundation
import SwiftUI

struct ModalizedView<Content : View>: View {
    let modalizedContent: Content
    let modalContent: Content
    let isModalized: Bool
    init(@ViewBuilder modalizedContent: () -> Content, modalContent: () -> Content, isModalized: Bool = false) {
        self.modalizedContent = modalizedContent()
        self.modalContent = modalContent()
        self.isModalized = isModalized
    }

    var body: some View {
        ZStack {
            modalizedContent
                .blur(radius: isModalized ? 2 : 0)
            if isModalized {
                Color.black
                    .opacity(0.6)
                VStack {
                    Spacer()
                    Rectangle()
                        .cornerRadius(25, corners: [.topLeft, .topRight])
                        .overlay {
                            modalContent
                        }
                        .foregroundColor(.white)
                        .frame(maxHeight: 400)

                }
            }
        }
        .ignoresSafeArea()
    }
}

struct ModalizedView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ModalizedView(modalizedContent: {
                VStack {
                    Text("Test")
                }
            }, modalContent: {
                VStack {
                    Text("Test 2")
                }
        })
            ModalizedView(modalizedContent: {
                VStack {
                    Text("Test")
                }
            }, modalContent: {
                VStack {
                    Text("Test 2")
                }
            })
                .previewDevice("iPhone 8")
        }
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
