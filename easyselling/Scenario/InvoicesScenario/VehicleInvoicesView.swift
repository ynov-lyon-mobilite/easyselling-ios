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
        VStack(alignment: .leading) {
            TitleNavigationView(title: L10n.Invoice.title)
            List(viewModel.invoices, id: \.id) { invoice in
                VStack {
                    VStack {
                        HStack {
                            Text(L10n.InvoiceCreation.Input.invoice)
                            Spacer()
                            Text(invoice.label)
                        }
                        Spacer()
                        HStack {
                            Text(L10n.InvoiceCreation.Input.mileage)
                            Spacer()
                            Text(String(invoice.mileage))
                        }
                    }
                    .padding()
                    .background(Color.white)
                }
                .cornerRadius(15)
                .padding(.top, 10)
                .onTapGesture {
                    Task {
                        await viewModel.downloadInvoiceContent(filename: invoice.file?.filename ?? "")
                    }
                }
                .swipeActions(edge: .trailing) {
                    Button(L10n.Invoice.deleteButton) {
                        Task {
                            await viewModel.deleteInvoice(idInvoice: invoice.id)
                        }
                    }.tint(.red)
                }
                .listRowSeparatorTint(.clear)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

            }
            .listStyle(.plain)

            Button(action: viewModel.openInvoiceCreation) {
                Text(L10n.CreateInvoice.Button.title)
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

        .task { await viewModel.getInvoices() }
    }
}

struct VehicleInvoicesView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = VehicleInvoiceViewModel(vehicle: Vehicle(id: "", brand: "", model: "", licence: "", type: .car, year: ""),
                                         onNavigatingToInvoiceView: {_ in },
                                         isOpeningInvoiceCreation: {_, _ in })
        vm.invoices = [Invoice(id: "ID", file: FileResponse(filename: ""), label: "Label", mileage: 10, date: Date(), vehicle: "")]
        vm.isLoading = false
        vm.isDownloading = true
        return VehicleInvoicesView(viewModel: vm)
    }
}
