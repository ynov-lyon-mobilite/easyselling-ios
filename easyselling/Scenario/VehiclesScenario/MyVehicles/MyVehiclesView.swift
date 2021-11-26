//
//  MyVehiclesView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 25/10/2021.
//

import SwiftUI

struct MyVehiclesView: View {

    @ObservedObject var viewModel: MyVehiclesViewModel

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.state == .loading {
                    ProgressView()
                } else if viewModel.state == .listingVehicles {
                    ScrollView(.vertical) {
                        VStack(spacing: 20) {
                            ForEach(viewModel.vehicles, id: \.id) { vehicle in
                                HStack {
                                    GeometryReader { geometry in
                                        ZStack {
                                            Circle()
                                                .frame(maxWidth: 40)
                                                .foregroundColor(.purple)
                                            Image(systemName: "person.fill")
                                        }
                                    }
                                    Spacer()
                                    Text(vehicle.brand)
                                }
                                .padding(.vertical, 15)
                                .padding(.leading, 20)
                                .frame(maxWidth: .infinity)
                            }
                            .background(.red.opacity(0.2))
                            .padding(.horizontal, 25)

                        }
                    }
                }
    //            else {
    //                Button(action: viewModel.openVehicleCreation) {
    //                    Text(L10n.CreateVehicle.title)
    //                }
    //
    //                List(viewModel.vehicles) { vehicule in
    //                    VStack {
    //                        HStack {
    //                            Text(vehicule.brand)
    //                            Text(vehicule.model)
    //                            Spacer()
    //                            Text(vehicule.type.description)
    //                        }
    //                        HStack {
    //                            Text(vehicule.license)
    //                            Spacer()
    //                            Text(vehicule.year)
    //                        }
    //                    }
    //                }.refreshable {
    //                    await viewModel.getVehicles()
    //                }
    //            }
            }
            .navigationTitle("Mes véhicules")
        }
        .onAppear {
            Task {
                await viewModel.getVehicles()
            }
        }
    }
}

struct MyVehiclesView_Previews: PreviewProvider {

    static var previews: some View {
        let vm = MyVehiclesViewModel(isOpenningVehicleCreation: {}, isNavigatingToProfile: {})
        vm.vehicles = [.init(brand: "Brand", model: "Model", license: "Licence", type: .car, year: "Year"),
                       .init(brand: "Brand", model: "Model", license: "Licence", type: .car, year: "Year"),
                       .init(brand: "Brand", model: "Model", license: "Licence", type: .car, year: "Year")]
        vm.state = .listingVehicles

        return MyVehiclesView(viewModel: vm)
    }
}
