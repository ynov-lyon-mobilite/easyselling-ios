//
//  ModalizedView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 01/02/2022.
//

import Foundation
import SwiftUI

struct ModalizedView<V: View, Content : View>: View {
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
                        .onTapGesture {
                            withAnimation {
                                isModalized = false
                            }
                        }
                }

                VStack {
                    Spacer()
                    modalContent
                        .padding(.bottom, reader.safeAreaInsets.bottom)
                        .cornerRadius(25, corners: [.topLeft, .topRight])
                }
                .ignoresSafeArea(edges: .vertical)
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
            VehicleCreationView(viewModel: VehicleCreationViewModel(hasFinishedVehicleCreation: {}))
        }
    }
}
