//
//  VehicleInvoicesView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 24/11/2021.
//

import SwiftUI

struct VehicleInvoicesView: View {

    @ObservedObject var viewModel: VehicleInvoiceViewModel

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                List {
                    ForEach(viewModel.invoices, id: \.id) { invoice in
                        VStack {
                            if viewModel.isDownloading && viewModel.chosenInvoice ?? 0 == invoice.id {
                                HStack {
                                    ProgressView()
                                }
                            } else {
                                HStack {
                                    Text("Vehicle Id :")
                                    Spacer()
                                    Text(invoice.vehicle)
                                }
                                Spacer()
                                HStack {
                                    Text("File Id :")
                                    Spacer()
                                    Text(invoice.file)
                                }
                            }
                        }
                        .onTapGesture {
                            viewModel.chosenInvoice = Int16(invoice.id)
                            Task {
                                await viewModel.downloadInvoiceContent(of: invoice.file)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(L10n.Invoice.deleteButton) {
                                Task {
                                    await viewModel.deleteInvoice(idInvoice: Int(invoice.id))
                                }
                            }.tint(.red)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.getInvoices(ofVehicleId: viewModel.vehicleId)
            }
        }
    }
}

struct VehicleInvoicesView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = VehicleInvoiceViewModel(ofVehicleId: "", onNavigatingToInvoiceView: {_ in })
        vm.invoices = []
        vm.isLoading = false
        vm.isDownloading = true
        return VehicleInvoicesView(viewModel: vm)
    }
}
