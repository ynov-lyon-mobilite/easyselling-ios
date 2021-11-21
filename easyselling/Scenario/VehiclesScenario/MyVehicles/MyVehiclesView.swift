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
                List {
                    if viewModel.state == .loading {
                        ProgressView()
                    } else if viewModel.state == .error {
                        Text(L10n.Error.occured)
                            .padding()
                            .listRowSeparatorTint(.clear)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    } else if viewModel.state == .listingVehicles {
                            ScrollView(.vertical) {
                                VStack(spacing: 20) {
                                    ForEach(viewModel.vehicles, id: \.id) { vehicle in
                                        HStack {
                                            Image(uiImage: vehicle.image)
                                                .padding(15)
                                                .background(Circle().foregroundColor(vehicle.imageColor))
                                            VStack(alignment: .leading) {
                                                Text("\(vehicle.brand) \(vehicle.model)")
                                                    .fontWeight(.bold)
                                                    .font(.title3)
                                                Text(vehicle.license)
                                                    .font(.body)
                                            }
                                            Spacer()
                                            VStack {
                                                Spacer()
                                                Text(vehicle.year)
                                            }
                                        }
                                        .padding(.vertical, 15)
                                        .padding(.horizontal, 20)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .background(vehicle.color)
                                        .cornerRadius(22)
                                        .padding(.horizontal, 25)
.swipeActions {
                        Button("Delete") {
                            Task {
                                await viewModel.deleteVehicle(idVehicle: vehicule.id)
                            }
                        }.tint(Asset.onBoardingDotActive.swiftUIColor)
}
                                    }
                                }
                            }
                            .listRowSeparatorTint(.clear)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    await viewModel.getVehicles()
                }
                Button(action: viewModel.openVehicleCreation) {
                    Image(systemName: "plus")
                        .foregroundColor(Asset.darkPurple.swiftUIColor)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(Asset.darkBlue.swiftUIColor)
                        .disabled(viewModel.state != .listingVehicles)
                        .opacity(viewModel.state != .listingVehicles ? 0 : 1)
                }
            }
            .navigationTitle(L10n.Vehicles.title)
            .toolbar {
                Button(L10n.Vehicles.profile) {
                        viewModel.navigateToProfile()
                }
            }
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
                       .init(brand: "Brand", model: "Model", license: "Licence", type: .moto, year: "Year"),
                       .init(brand: "Brand", model: "Model", license: "Licence", type: .car, year: "Year")]
        vm.state = .error

        return MyVehiclesView(viewModel: vm)
    }
}
