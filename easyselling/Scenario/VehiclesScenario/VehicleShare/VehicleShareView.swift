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

//    var body: some View {
//        NavigationView {
//            VStack {
//                List {
//                    HStack {
//                        Image(uiImage: viewModel.vehicle.image)
//                            .padding(15)
//                            .background(Circle().foregroundColor(viewModel.vehicle.imageColor))
//                        VStack(alignment: .leading) {
//                            Text("\(viewModel.vehicle.brand) \(viewModel.vehicle.model)")
//                                .fontWeight(.bold)
//                                .font(.title3)
//                            Text(viewModel.vehicle.license)
//                                .font(.body)
//                        }
//                        Spacer()
//                        VStack {
//                            Spacer()
//                            Text(viewModel.vehicle.year)
//                        }
//                    }
//                    .padding(.vertical, 15)
//                    .padding(.horizontal, 20)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .background(viewModel.vehicle.color)
//                    .cornerRadius(22)
//                    .padding(.horizontal, 25)
//                    .padding(.vertical)
//                    Text(L10n.ShareVehicle.hint)
//                    TextField(L10n.SignUp.mail, text: $viewModel.email)
//                        .padding(10)
//                        .background(Color.gray.opacity(0.5))
//                        .cornerRadius(10)
//                        .textContentType(.emailAddress)
//                    Button(action: { Task {
//                        await viewModel.shareVehicle()
//                    }}) {
//                        if viewModel.state == .loading {
//                            ProgressView()
//                        } else if viewModel.state == .sharingVehicle {
//                            Text(L10n.ShareVehicle.send)
//                        }
//                    }
//                    .buttonStyle(PrimaryButtonStyle())
//                    .ignoresSafeArea(.keyboard, edges: .bottom)
//
//                }
//                .listStyle(.plain)
//            }
//            .navigationTitle(L10n.ShareVehicle.title)
//        }
//        .ableToShowError(viewModel.error)
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//    }

    var body: some View {
        VStack(spacing: 40) {
            HStack {
                Image(uiImage: viewModel.vehicle.image)
                    .padding(15)
                    .background(Circle().foregroundColor(viewModel.vehicle.imageColor))
                VStack(alignment: .leading) {
                    Text("\(viewModel.vehicle.brand) \(viewModel.vehicle.model)")
                        .fontWeight(.bold)
                        .font(.title3)
                    Text(viewModel.vehicle.license)
                        .font(.body)
                }
                Spacer()
                VStack(alignment: .center) {
                    Spacer()
                    Text(viewModel.vehicle.year)
                }
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(viewModel.vehicle.color)
            .cornerRadius(22)
            .frame(height: 100)
            VStack {
                Text(L10n.ShareVehicle.hint)
                TextField(L10n.SignUp.mail, text: $viewModel.email)
                    .padding(10)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
                    .textContentType(.emailAddress)
            }

            Button(action: { Task {
                await viewModel.shareVehicle()
            }}) {
                if viewModel.state == .loading {
                    ProgressView()
                } else if viewModel.state == .sharingVehicle {
                    Text(L10n.ShareVehicle.send)
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(25)
        .ableToShowError(viewModel.error)
    }
}
