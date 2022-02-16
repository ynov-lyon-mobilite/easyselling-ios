//
//  ModalizedView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 01/02/2022.
//

import Foundation
import SwiftUI

private struct ModalizedView<V: View, Content : View>: View {
    let modalizedContent: V
    @ViewBuilder let modalContent: Content
    @Binding var isModalized: Bool

    var body: some View {
        GeometryReader { reader in
            ZStack {
                modalizedContent
                    .blur(radius: isModalized ? 2 : 0)
                    .disabled(isModalized)
                if isModalized {
                    Color.black
                        .opacity(0.6)
                        .ignoresSafeArea()
                }

                VStack {
                    Spacer()
                    modalContent
                        .padding(.bottom, reader.safeAreaInsets.bottom)
                        .cornerRadius(25, corners: [.topLeft, .topRight])
                }
                .ignoresSafeArea(edges: .bottom)
                .offset(y: isModalized ? 0 : reader.size.height)
            }
        }
    }
}

struct ModalizedView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                Text("Test")
            }

            VStack {
                Text("Test")
            }
            .previewDevice("iPhone 8")

        }.modal(isModalized: .constant(true)) {
            VehicleCreationView(viewModel: VehicleCreationViewModel(isOpenningVehicleCreation: .constant(true)))
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

    func modal<Content: View>(isModalized: Binding<Bool>, @ViewBuilder modalContent: @escaping () -> Content) -> some View {
        return ModalizedView(modalizedContent: self, modalContent: modalContent, isModalized: isModalized)
    }
}
