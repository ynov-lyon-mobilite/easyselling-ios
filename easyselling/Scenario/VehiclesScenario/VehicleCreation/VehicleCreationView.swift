//
//  VehicleCreationView.swift
//  easyselling
//
//  Created by Valentin Mont School on 13/10/2021.
//

import SwiftUI

struct VehicleCreationView: View {

    @ObservedObject var viewModel: VehicleCreationViewModel

    var body: some View {
        VStack(spacing: 15) {
            VStack {
                Text(viewModel.title)
                        .foregroundColor(Asset.Colors.primary.swiftUIColor)
                        .font(.title2)
                        .bold()
                        .transition(AnyTransition.opacity.combined(with: .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))))

                VStack(spacing: 20) {
                    if viewModel.vehicleCreationStep == .vehicleType {
                        VehicleFormButton(action: {viewModel.selectType(.car)}, title: "Une voiture", isSelected: viewModel.type == .car)
                        VehicleFormButton(action: {viewModel.selectType(.moto)}, title: "Une moto", isSelected: viewModel.type == .moto)
                    } else if viewModel.vehicleCreationStep == .licence {
                        VehicleFormTextField(text: $viewModel.license, placeholder: "Immatriculation")
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    } else if viewModel.vehicleCreationStep == .brandAndModel {
                        VehicleFormTextField(text: $viewModel.brand, placeholder: "Marque")
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        VehicleFormTextField(text: $viewModel.model, placeholder: "Modèle")
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    } else if viewModel.vehicleCreationStep == .year {
                        VehicleFormTextField(text: $viewModel.year, placeholder: "JJ/MM/AAAA")
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    }
                }
                .padding(.top, 20)
            }
            Spacer()
            Button("Continuer", action: withAnimation {
                viewModel.continueVehicleCreation
            })
                    .buttonStyle(PrimaryButtonStyle())

            Button(action: viewModel.goingToPrevious) {
                    Text("Précédent")
                    .foregroundColor(Color.black)
                    .bold()
            }
                .padding(.bottom, 20)

            DotControlView(totalElements: viewModel.vehicleCreationStep.count, contentIndex: viewModel.vehicleCreationStep.currentIndex)
            }
            .frame(height: 350)
            .padding([.leading, .trailing, .bottom], 25)
            .padding(.top, 10)
            .background(Asset.Colors.whiteBackground.swiftUIColor)
    }
}

struct VehicleCreationView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = VehicleCreationViewModel(vehicleCreator: DefaultVehicleCreator(), vehicleVerificator: DefaultVehicleInformationsVerificator(), isOpenningVehicleCreation: .constant(true))
        viewModel.vehicleCreationStep = .vehicleType

            return VehicleCreationView(viewModel: viewModel)
            .previewLayout(PreviewLayout.sizeThatFits)
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
