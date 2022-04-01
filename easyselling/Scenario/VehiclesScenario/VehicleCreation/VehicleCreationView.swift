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
                            .animation(nil)

                    VStack(spacing: 20) {
                        Spacer()
                        if viewModel.vehicleCreationStep == .vehicleType {
                            Button(L10n.Vehicles.car) {
                                viewModel.selectType(.car)
                            }
                            .buttonStyle(VehicleFormButtonStyle(isSelected: viewModel.type == .car))
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                            Button(L10n.Vehicles.moto) {
                                viewModel.selectType(.moto)
                            }
                            .buttonStyle(VehicleFormButtonStyle(isSelected: viewModel.type == .moto))
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))

                        } else if viewModel.vehicleCreationStep == .licence {
                            TextField(L10n.CreateVehicle.licence, text: $viewModel.licence)
                                .textFieldStyle(VehicleFormTextFieldStyle())
                                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))

                            Text(L10n.CreateVehicle.Form.adviceForlicence)
                                .font(.subheadline)
                                .italic()
                                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        } else if viewModel.vehicleCreationStep == .brandAndModel {

                            TextField(L10n.CreateVehicle.brand, text: $viewModel.brand)
                                .textFieldStyle(VehicleFormTextFieldStyle())
                                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))

                            TextField(L10n.CreateVehicle.model, text: $viewModel.model)
                                .textFieldStyle(VehicleFormTextFieldStyle())
                                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))

                        } else if viewModel.vehicleCreationStep == .year {
                            Picker("", selection: $viewModel.year) {
                                ForEach(viewModel.rangeOfYears, id: \.self) {
                                                Text($0)
                                            }
                                        }
                            .pickerStyle(.wheel)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        }
                        Spacer()
                    }
                    .frame(maxHeight: 160)
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
