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
            Text(viewModel.title)
                    .foregroundColor(Asset.Colors.primary.swiftUIColor)
                    .font(.title2)
                    .bold()

            VStack(spacing: 20) {
                if viewModel.vehicleCreationStep == .vehicleType {
                    VehicleFormButton(action: {viewModel.selectType(.car)}, title: "Une voiture", isSelected: viewModel.selectedType)
                    VehicleFormButton(action: {viewModel.selectType(.moto)}, title: "Une moto", isSelected: viewModel.selectedType)
                } else if viewModel.vehicleCreationStep == .licence {
                    VehicleFormTextField(text: $viewModel.license, placeholder: "Immatriculation")
                } else if viewModel.vehicleCreationStep == .brandAndModel {
                    VehicleFormTextField(text: $viewModel.brand, placeholder: "Marque")
                    VehicleFormTextField(text: $viewModel.model, placeholder: "Modèle")
                } else if viewModel.vehicleCreationStep == .year {
                    VehicleFormTextField(text: $viewModel.year, placeholder: "JJ/MM/AAAA")
                }
            }
            .padding(.top, 20)

            Button("Continuer", action: viewModel.continueVehicleCreation)
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.vertical, 20)

                DotControlView(totalElements: 4, contentIndex: 0)
            }
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

//
//            Text(L10n.CreateVehicle.title)
//                .font(.title)
//                .fontWeight(.bold)
//
//            Divider()
//
//            TextField(L10n.CreateVehicle.brand, text: $viewModel.brand)
//                .padding(.top)
//
//            TextField(L10n.CreateVehicle.model, text: $viewModel.model)
//                .padding(.top)
//
//            TextField(L10n.CreateVehicle.license, text: $viewModel.license)
//                .padding(.top)
//
//            Text(L10n.CreateVehicle.Form.adviceForLicense)
//                .font(.system(size: 13))
//                .frame(maxWidth: .infinity, alignment: .leading)
//
//            HStack(alignment: .lastTextBaseline) {
//                Picker("Type", selection: $viewModel.type) {
//                    Text(L10n.Vehicles.car).tag(Vehicle.Category.car)
//                    Text(L10n.Vehicles.moto).tag(Vehicle.Category.moto)
//                }
//                Spacer(minLength: 50)
//                TextField(L10n.CreateVehicle.year, text: $viewModel.year)
//                    .padding(.top)
//                    .keyboardType(.numberPad)
//            }
//
//            Button(L10n.CreateVehicle.submit) {
//                Task {
//                    await viewModel.createVehicle()
//                }
//            }
//            .padding(.top)
//            Spacer()

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
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
