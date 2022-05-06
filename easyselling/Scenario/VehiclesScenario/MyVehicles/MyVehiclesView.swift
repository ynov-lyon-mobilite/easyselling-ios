//
//  MyVehiclesView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 25/10/2021.
//

import SwiftUI

struct MyVehiclesView: View {

    @ObservedObject var viewModel: MyVehiclesViewModel
    @State private var vehicleShowed = 0
    @State var showLoader = false

    var body: some View {

        VStack(alignment: .leading) {
            TitleNavigationView(title: L10n.Vehicles.title)

            Picker(L10n.Vehicles.chooseList, selection: $vehicleShowed) {
                Text(L10n.Vehicles.List.myVehicles).tag(0)
                Text(L10n.Vehicles.List.sharedVehicles).tag(1)
            }
            .pickerStyle(.segmented)

            if vehicleShowed == 0 {
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
                            SwipeableVehicleListElement(vehicle: vehicle,
                                                        deleteAction: { Task {
                                withAnimation(.spring()) {showLoader.toggle()}
                                await viewModel.deleteVehicle(idVehicle: vehicle.id )
                                withAnimation(.spring()) {showLoader.toggle()}
                            } },
                                                        updateAction: { viewModel.openVehicleUpdate(vehicle: vehicle) },
                                                        shareAction: { viewModel.openVehicleShare(vehicle: vehicle) },
                                                        showInvoices: { viewModel.navigatesToInvoices(vehicle: vehicle) })
                                .redacted(when: viewModel.state == .loading)
                        }
                        .listRowSeparatorTint(.clear)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

                    }
                }
                .listStyle(.plain)
                .refreshable {
                    withAnimation(.spring()) {showLoader.toggle()}
                    await viewModel.getVehicles()
                    withAnimation(.spring()) {showLoader.toggle()}
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
            } else {
                VStack {
                    List {
                        ForEach(viewModel.filteredVehicle, id: \.id) { sharedVehicle in
                            VehicleListElement(vehicle: sharedVehicle, action: {})
                                .listRowSeparatorTint(.clear)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                    }
                    .listStyle(.plain)
                }
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity)
            }
        }
        .padding(.horizontal, 25)
        .background(Asset.Colors.backgroundColor.swiftUIColor)
        .onAppear {
            UITableView.appearance().showsVerticalScrollIndicator = false
            Task {
                withAnimation(.spring()) {showLoader.toggle()}
                await viewModel.getVehicles()
                withAnimation(.spring()) {showLoader.toggle()}
            }
            UIRefreshControl.appearance().isOpaque = false
        }
        .modal(isModalized: $viewModel.isOpenningVehicleCreation) {
            VehicleCreationView(viewModel: VehicleCreationViewModel(hasFinishedVehicleCreation: {
                $viewModel.isOpenningVehicleCreation.wrappedValue.toggle()
                Task {
                    withAnimation(.spring()) {showLoader.toggle()}
                    await viewModel.getVehicles()
                    withAnimation(.spring()) {showLoader.toggle()}
                }
                UIRefreshControl.appearance().isOpaque = false
            }))
        }
        .ableToShowError(viewModel.error)
        .overlay(
            ZStack {
                if showLoader {
                    Color.primary.opacity(0.2)
                        .ignoresSafeArea()
                }

                Loader()
                    .offset(y: showLoader ? 0 : UIScreen.main.bounds.height)
            }
        )
    }
}

struct MyVehiclesView_Previews: PreviewProvider {

    static var previews: some View {
        let vm = MyVehiclesViewModel(
            isOpeningVehicleUpdate: {_,_ in },
            isNavigatingToInvoices: {_ in },
            isOpeningVehicleShare: {_ in})
        vm.vehicles = [Vehicle(id: "ID", brand: "Brand", model: "Model", licence: "licence", type: .car, year: "Year"),
                       Vehicle(id: "ID", brand: "Brand", model: "Model", licence: "licence", type: .moto, year: "Year"),
                       Vehicle(id: "ID", brand: "Brand", model: "Model", licence: "licence", type: .car, year: "Year")]
        vm.state = .listingVehicles

        return MyVehiclesView(viewModel: vm)
    }
}
