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
                List(viewModel.invoices, id: \.id) { invoice in
                    VStack {
                        if viewModel.isDownloading {
                            HStack {
                                ProgressView()
                            }
                        } else {
                            HStack {
                                Text("Invoice Id :")
                                Spacer()
                                Text(invoice.id)
                            }
                            Spacer()
                            HStack {
                                Text("File Id :")
                                Spacer()
                                // Text(invoice.file.filename)
                            }
                        }
                    }
                    .alert(isPresented: $viewModel.isError, content: {
                        Alert(
                            title: Text(viewModel.error?.errorDescription ?? ""),
                            dismissButton: Alert.Button.default(Text(L10n.Button.ok)))
                    })
                    .onTapGesture {
                        Task {
                            await viewModel.downloadInvoiceContent(filename: invoice.file?.filename ?? "")
                        }
                    }
                    swipeActions(edge: .trailing) {
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
        let vm = VehicleInvoiceViewModel(vehicle: Vehicle(id: "", brand: "", model: "", licence: "", type: .car, year: ""), onNavigatingToInvoiceView: {_ in }, isOpeningInvoiceCreation: {_, _ in })
        vm.invoices = [Invoice(id: "ID", fileData: Data(), file: FileResponse(filename: ""))]
        vm.isLoading = false
        vm.isDownloading = true
        return VehicleInvoicesView(viewModel: vm)
    }
}
