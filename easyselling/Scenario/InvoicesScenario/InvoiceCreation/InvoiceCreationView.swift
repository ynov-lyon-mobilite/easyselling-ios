//
//  InvoiceCreationView.swift
//  easyselling
//
//  Created by Corentin Laurencine on 15/12/2021.
//

import SwiftUI
import UniformTypeIdentifiers

struct InvoiceCreationView: View {

    @ObservedObject var viewModel: InvoiceCreationViewModel

    var body: some View {
        NavigationView {
            VStack(alignment: .center) {

                VStack(alignment: .center, spacing: 40) {

                    if let file = viewModel.uploadedFile {
                        Text(file.filename)
                    } else {
                        Button(action: { viewModel.openFileConfirmationDialog() }) {
                            VStack {
                                Image(systemName: "folder.badge.plus")
                                    .font(.largeTitle)
                                    .foregroundColor(Color.white)
                                    .padding()
                            }
                            .background(Color.primaryEasyselling)
                            .cornerRadius(15)
                        }
                    }

                    DatePicker(selection: $viewModel.invoiceDate, in: ...Date(), displayedComponents: .date) {
                        Text("Date de la facture")
                            .font(.title3)
                    }
                    .datePickerStyle(.compact)

                    TextField("Kilométrage à date de facture", value: $viewModel.invoiceMileage, format: .number)
                        .textFieldStyle(VehicleFormTextFieldStyle())

                    TextField("Nom de la facture", text: $viewModel.invoiceLabel)
                        .textFieldStyle(VehicleFormTextFieldStyle())

                }
                .padding(.top, 25)

                Spacer()

                if viewModel.isReadyToAdd {
                    Button(action: { Task {
                        await viewModel.createInvoice()
                    } }) {
                        Text(L10n.CreateInvoice.Create.Button.title)
                            .font(.title2)
                            .foregroundColor(Color.white)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background(Asset.Colors.primary.swiftUIColor)
                            .cornerRadius(22)
                    }
                    .padding(.bottom)
                }
            }
            .padding()
            .background(Color.backgroundColor)
            .fileImporter(isPresented: .constant(viewModel.fileSelectionType == .upload), allowedContentTypes: viewModel.allowedFileType) { result in
                Task {
                    await viewModel.importFile(result: result)
                }
            }
            .confirmationDialog("", isPresented: $viewModel.fileConfirmationDialogIsPresented) {
                Button(L10n.InvoiceCreation.Button.upload) { viewModel.openFileSectionSheet(.upload) }
                Button(L10n.InvoiceCreation.Button.scan) { viewModel.openFileSectionSheet(.scan) }
            }
            .alert(
                Text(""),
                isPresented: $viewModel.alertIsPresented,
                presenting: viewModel.alertError,
                actions: { _ in EmptyView() }, message: { (item: Error) in
                    Text(item.localizedDescription)
                }
            )
            .navigationBarTitle(
                Text("\(viewModel.vehicle.brand) \(viewModel.vehicle.model)"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct InvoiceCreationView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceCreationView(
            viewModel: InvoiceCreationViewModel(
                vehicle: .init(id: "abcdefgh", brand: "Renault", model: "R5",
                               licence: "AA-123-BB", type: .car, year: "2001"),
                onFinish: {})
        )
    }
}
