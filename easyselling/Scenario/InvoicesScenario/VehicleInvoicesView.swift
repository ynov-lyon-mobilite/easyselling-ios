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
                    .onTapGesture {
                        Task {
                            await viewModel.downloadInvoiceContent(of: invoice.file)
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
        VehicleInvoicesView(viewModel: VehicleInvoiceViewModel(ofVehicleId: "", onNavigatingToInvoiceView: {_ in }))
    }
}
