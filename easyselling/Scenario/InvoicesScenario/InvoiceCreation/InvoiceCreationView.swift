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
        VStack(alignment: .leading) {
            HStack {
                Text("\(viewModel.vehicle.brand) \(viewModel.vehicle.model))
                     Text("\(viewModel.vehicle.licence)")
            }
            Text("\(viewModel.vehicle.brand) \(viewModel.vehicle.model) - \(viewModel.vehicle.licence)")

            if let file = viewModel.uploadedFile {
                Text(file.filename)
            } else {
                Button(action: { viewModel.openFileConfirmationDialog() }) {
                    Text(L10n.InvoiceCreation.Label.addFile)
                }
            }
            Spacer()

            Button(action: { Task {
                await viewModel.createInvoice()
            } }) {
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
        .padding()
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
