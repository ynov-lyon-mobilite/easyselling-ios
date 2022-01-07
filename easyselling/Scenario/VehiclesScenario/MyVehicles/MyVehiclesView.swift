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
                            .swipeActions(edge: .trailing) {
                                Button(L10n.Vehicles.deleteButton) {
                                    Task {
                                        await viewModel.deleteVehicle(idVehicle: vehicle.id ?? "")
                                    }
                                }.tint(Color.red)
                                Button(L10n.Vehicles.updateButton) {
                                        viewModel.openVehicleUpdate(vehicle: vehicle)
                                }.tint(Color.secondaryEasyselling)
                            }
                            .padding(.vertical, 15)
                            .padding(.horizontal, 20)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(vehicle.color)
                            .cornerRadius(22)
                            .padding(.horizontal, 25)
                            .padding(.vertical)
                            .onTapGesture {
                                viewModel.navigatesToInvoices(ofVehicle: vehicle.id ?? "")
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
                Button("SETTINGS") {
                    viewModel.navigatesToSettingsMenu()
                }
                Button(action: viewModel.openVehicleCreation) {
                    Image(systemName: "plus")
                        .foregroundColor(Asset.Colors.secondary.swiftUIColor)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(Asset.Colors.primary.swiftUIColor)
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
        let vm = MyVehiclesViewModel(isOpenningVehicleCreation: {},
                                     isOpeningVehicleUpdate: {_,_ in },
                                     isNavigatingToProfile: {},
                                     isNavigatingToInvoices: {_ in },
                                     isNavigatingToSettingsMenu: {})
        vm.vehicles = [Vehicle()]
        vm.state = .listingVehicles

        return MyVehiclesView(viewModel: vm)
    }
}
