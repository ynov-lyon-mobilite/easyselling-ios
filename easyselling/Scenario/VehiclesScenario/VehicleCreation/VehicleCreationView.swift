//
//  VehicleCreationView.swift
//  easyselling
//
//  Created by Valentin Mont School on 13/10/2021.
//

import SwiftUI
import Combine

struct VehicleCreationView: View {
    @State private var keyboardHeight: CGFloat = 20
    @State private var isKeyboardOpen: Bool = false
    @ObservedObject var viewModel: VehicleCreationViewModel

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 15) {
                VStack {
                    Text(viewModel.title)
                            .foregroundColor(Asset.Colors.primary.swiftUIColor)
                            .font(.title2)
                            .bold()

                    VStack(spacing: 20) {
                        Spacer()
                        if viewModel.vehicleCreationStep == .vehicleType {
                            VehicleFormButton(action: {viewModel.selectType(.car)}, title: L10n.Vehicles.car, isSelected: viewModel.type == .car)
                                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                            VehicleFormButton(action: {viewModel.selectType(.moto)}, title: L10n.Vehicles.moto, isSelected: viewModel.type == .moto)
                                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        } else if viewModel.vehicleCreationStep == .licence {
                            VehicleFormTextField(text: $viewModel.license, placeholder: L10n.CreateVehicle.license)
                                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        } else if viewModel.vehicleCreationStep == .brandAndModel {
                            VehicleFormTextField(text: $viewModel.brand, placeholder: L10n.CreateVehicle.brand)
                                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                            VehicleFormTextField(text: $viewModel.model, placeholder: L10n.CreateVehicle.model)
                                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        } else if viewModel.vehicleCreationStep == .year {
                            VehicleFormTextField(text: $viewModel.year, placeholder: L10n.CreateVehicle.year)
                                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        }
                        Spacer()
                    }
                    .frame(maxHeight: 150)
                }

                HStack {

                    Button(action: viewModel.goingToPrevious, label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                            .padding()
                    })
                        .opacity(viewModel.vehicleCreationStep == .vehicleType ? 0 : 1)
                        .disabled(viewModel.vehicleCreationStep == .vehicleType)

                    Spacer()
                    DotControlView(totalElements: viewModel.vehicleCreationStep.count, contentIndex: viewModel.vehicleCreationStep.currentIndex)

                    Spacer()
                    if viewModel.vehicleCreationStep != .year {
                        Button(action: viewModel.continueVehicleCreation, label: {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .padding()
                                .background(Asset.Colors.primary.swiftUIColor
                                                .clipShape(Circle()))
                                .opacity(viewModel.vehicleCreationStep == .vehicleType ? 0 : 1)
                                .disabled(viewModel.vehicleCreationStep == .vehicleType)
                        })
                    } else {
                        Button(action: { Task {
                            await viewModel.createVehicle()
                        }  }, label: {
                            Image(systemName: "checkmark")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .padding()
                                .background(Asset.Colors.primary.swiftUIColor
                                                .clipShape(Circle()))
                        })
                    }
                }
            }
            .padding([.leading, .trailing, .bottom], 25)
            .padding(.top, 16)
            .background(Asset.Colors.whiteBackground.swiftUIColor)
            .cornerRadius(40)
            .padding(.horizontal, 8)
            .padding(.bottom, keyboardHeight)
                    .onReceive(Publishers.keyboardHeight) { padding in
                        withAnimation {
                            self.keyboardHeight = padding
                        }
                    }
        }
        .background(Color.clear)
        .ableToShowError(viewModel.error)
    }
}

struct VehicleCreationView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = VehicleCreationViewModel(
            vehicleCreator: DefaultVehicleCreator(),
            vehicleVerificator: DefaultVehicleInformationsVerificator(),
            hasFinishedVehicleCreation: {})
        viewModel.vehicleCreationStep = .vehicleType

        return Group {
            VehicleCreationView(viewModel: viewModel)
            VehicleCreationView(viewModel: viewModel)
                .previewDevice("iPhone 8")
        }
    }
}

struct CheckToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Label {
                configuration.label
            } icon: {
            }
        }
        .buttonStyle(ToggleButtonStyle(isOn: configuration.$isOn))
    }
}

extension Publishers {
    // 1.
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        // 2.
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }

        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(20) }

        // 3.
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}
