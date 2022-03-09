//
//  VehicleShareView.swift
//  easyselling
//
//  Created by Théo Tanchoux on 16/02/2022.
//

import Foundation
import SwiftUI

struct VehicleShareView: View {
    @ObservedObject var viewModel: VehicleShareViewModel

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
                    } else if viewModel.state == .displayingVehicle && viewModel.vehicle != nil {
                        HStack {
                            Image(uiImage: viewModel.vehicle!.image)
                                .padding(15)
                                .background(Circle().foregroundColor(viewModel.vehicle!.imageColor))
                            VStack(alignment: .leading) {
                                Text("\(viewModel.vehicle!.brand) \(viewModel.vehicle!.model)")
                                    .fontWeight(.bold)
                                    .font(.title3)
                                Text(viewModel.vehicle!.license)
                                    .font(.body)
                            }
                            Spacer()
                            VStack {
                                Spacer()
                                Text(viewModel.vehicle!.year)
                            }
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(viewModel.vehicle!.color)
                        .cornerRadius(22)
                        .padding(.horizontal, 25)
                        .padding(.vertical)
                    }
                    Text(L10n.ShareVehicle.hint)
                    TextField(L10n.SignUp.mail, text: $viewModel.email)
                        .padding(10)
                        .background(Color.gray.opacity(0.5))
                        .cornerRadius(10)
                        .textContentType(.emailAddress)
                    Button(action: { Task {
                        // TODO: Call API /:vehicleId/share
                    }}) {
                        Text(L10n.ShareVehicle.send)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .ignoresSafeArea(.keyboard, edges: .bottom)

                }
                .listStyle(.plain)
                .refreshable {
                    await viewModel.getVehicle()
                }
            }
            .navigationTitle(L10n.ShareVehicle.title)
        }
        .onAppear {
            Task {
                await viewModel.getVehicle()
            }
        }
    }
}
