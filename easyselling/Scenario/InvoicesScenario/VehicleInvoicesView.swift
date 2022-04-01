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
                List(viewModel.invoices) { invoice in
                    VStack {
                        if viewModel.isDownloading {
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
                                Text(invoice.file.filename)
                            }
                        }
                    }
                    .onTapGesture {
                        Task {
                            await viewModel.downloadInvoiceContent(filename: invoice.file.filename)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button(L10n.Invoice.deleteButton) {
                            Task {
                                await viewModel.deleteInvoice(idInvoice: invoice.id)
                            }
                        }.tint(.red)
                    }
                }
                Button(action: viewModel.openInvoiceCreation) {
                    Image(systemName: "plus")
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .task { await viewModel.getInvoices() }
    }
}

struct VehicleInvoicesView_Previews: PreviewProvider {
    static var previews: some View {
        let vehicle = Vehicle(id: "1098HFD10°H", brand: "Yamaha", model: "XJ6", licence: "AA-123-BB", type: .moto, year: "2013")
        let vm = VehicleInvoiceViewModel(vehicle: vehicle, onNavigatingToInvoiceView: { _ in }, isOpeningInvoiceCreation: { _,_  in })
        vm.invoices = [Invoice(id: "123DAEA", vehicle: "1098HFD10°H", file: .preview)]
        vm.isLoading = false
        vm.isDownloading = true
        return VehicleInvoicesView(viewModel: vm)
    }
}
