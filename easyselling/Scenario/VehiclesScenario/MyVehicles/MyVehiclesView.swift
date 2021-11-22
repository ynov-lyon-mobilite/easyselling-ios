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
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                Button(action: viewModel.openVehicleCreation) {
                    Text(L10n.CreateVehicle.title)
                }

                List(viewModel.vehicles) { vehicule in
                    VStack {
                        HStack {
                            Text(vehicule.brand)
                            Text(vehicule.model)
                            Spacer()
                            Text(vehicule.type.description)
                        }
                        HStack {
                            Text(vehicule.license)
                            Spacer()
                            Text(vehicule.year)
                        }
                    }
                }.refreshable {
                    await viewModel.getVehicles()
                }
            }
        }
        .alert(isPresented: $viewModel.isError, content: {
            Alert(title: Text(viewModel.error?.errorDescription ?? ""), dismissButton: Alert.Button.default(Text("Ok"))
            )
        })
        .onAppear {
            Task {
                await viewModel.getVehicles()
            }
        }
    }
}

struct MyVehiclesView_Previews: PreviewProvider {
    static var previews: some View {
        MyVehiclesView(viewModel: MyVehiclesViewModel(isOpenningVehicleCreation: {}))
    }
}
