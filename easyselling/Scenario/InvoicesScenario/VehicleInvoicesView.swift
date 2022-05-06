//
//  VehicleInvoicesView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 24/11/2021.
//

import SwiftUI

struct VehicleInvoicesView: View {

    @ObservedObject var viewModel: VehicleInvoiceViewModel
    @State var showLoader = false

    var body: some View {
        VStack(alignment: .leading) {
            TitleNavigationView(title: L10n.Invoice.title)
            List(viewModel.invoices, id: \.id) { invoice in
                VStack {
                    Image(uiImage: UIImage())
                        .frame(height: 200)
                    VStack {
                        HStack {
                            Text("Vehicle Id :")
                            Spacer()
                            Text(invoice.id)
                        }
                        Spacer()
                        HStack {
                            Text("File Id :")
                            Spacer()
                            Text(invoice.file?.filename ?? "")
                        }
                    }
                    .padding()
                    .background(Color.white)
                }
                .cornerRadius(15)
                .onTapGesture {
                    Task {
                        withAnimation(.spring()) {showLoader.toggle()}
                        await viewModel.downloadInvoiceContent(filename: invoice.file?.filename ?? "")
                        withAnimation(.spring()) {showLoader.toggle()}
                    }
                }
                .swipeActions(edge: .trailing) {
                    Button(L10n.Invoice.deleteButton) {
                        Task {
                            withAnimation(.spring()) {showLoader.toggle()}
                            await viewModel.deleteInvoice(idInvoice: invoice.id)
                            withAnimation(.spring()) {showLoader.toggle()}
                        }
                    }.tint(.red)
                }
                .listRowSeparatorTint(.clear)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

            }
            .listStyle(.plain)

            Button(action: viewModel.openInvoiceCreation) {
                Text(L10n.CreateVehicle.title)
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
        //        .task {
        //            withAnimation(.spring()) {showLoader.toggle()}
        //            await viewModel.getInvoices()
        //            withAnimation(.spring()) {showLoader.toggle()} }
        .onAppear {
            UITableView.appearance().showsVerticalScrollIndicator = false
            Task {
                withAnimation(.spring()) {showLoader.toggle()}
                await viewModel.getInvoices()
                withAnimation(.spring()) {showLoader.toggle()}
            }
            UIRefreshControl.appearance().isOpaque = false
        }
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

struct VehicleInvoicesView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = VehicleInvoiceViewModel(vehicle: Vehicle(id: "", brand: "", model: "", licence: "", type: .car, year: ""),
                                         onNavigatingToInvoiceView: {_ in },
                                         isOpeningInvoiceCreation: {_, _ in })
        vm.invoices = [Invoice(id: "ID", fileData: Data(), file: FileResponse(filename: ""))]
        vm.isLoading = false
        vm.isDownloading = true
        return VehicleInvoicesView(viewModel: vm)
    }
}
