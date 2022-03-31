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

        VStack(alignment: .leading) {
            TitleNavigationView(title: L10n.Vehicles.title)
            SearchBar(searchText: $viewModel.searchFilteringVehicle)
            List {
                if viewModel.state == .error {
                    HStack {
                        Spacer()
                        Text(L10n.Error.occured)
                        Spacer()
                    }
                    .padding()
                    .listRowSeparatorTint(.clear)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                } else {
                    ForEach(viewModel.filteredVehicle, id: \.id) { vehicle in
                        VehicleListElement(vehicle: vehicle,
                                           deleteAction: { Task {
                            await viewModel.deleteVehicle(idVehicle: vehicle.id ?? "")
                        } },
                                           updateAction: { viewModel.openVehicleUpdate(vehicle: vehicle) },
                                           showInvoices: { viewModel.navigatesToInvoices(ofVehicle: vehicle.id ?? "") })
                            .redacted(when: viewModel.state == .loading)
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
                    Text(L10n.CreateVehicle.title)
                        .font(.title2)
                        .foregroundColor(Color.white)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(Asset.Colors.primary.swiftUIColor)
                        .cornerRadius(22)
                }
                .padding(.bottom)
        }
        .padding(.horizontal, 25)
        .background(Asset.Colors.backgroundColor.swiftUIColor)
        .onAppear {
            UITableView.appearance().showsVerticalScrollIndicator = false

            Task {
                await viewModel.getVehicles()
            }
        }
        .modal(isModalized: $viewModel.isOpenningVehicleCreation) {
            VehicleCreationView(viewModel: VehicleCreationViewModel(hasFinishedVehicleCreation: {
                $viewModel.isOpenningVehicleCreation.wrappedValue.toggle()
                Task {
                    await viewModel.getVehicles()
                }
            }))
        }
    }
}

struct MyVehiclesView_Previews: PreviewProvider {

    static var previews: some View {
        let vm = MyVehiclesViewModel(
            isOpeningVehicleUpdate: {_,_ in },
            isNavigatingToInvoices: {_ in })
        vm.vehicles = [Vehicle(id: "ID", brand: "Brand", model: "Model", license: "Licence", type: .car, year: "Year"),
                       Vehicle(id: "ID", brand: "Brand", model: "Model", license: "Licence", type: .moto, year: "Year"),
                       Vehicle(id: "ID", brand: "Brand", model: "Model", license: "Licence", type: .car, year: "Year")]
        vm.state = .listingVehicles

        return MyVehiclesView(viewModel: vm)
    }
}
