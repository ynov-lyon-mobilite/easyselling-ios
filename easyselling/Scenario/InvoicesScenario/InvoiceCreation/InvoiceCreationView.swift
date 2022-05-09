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
    @State var showLoader = false

    var body: some View {
        VStack(alignment: .leading) {
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
                withAnimation(.spring()) {showLoader.toggle()}
                await viewModel.createInvoice() }
                withAnimation(.spring()) {showLoader.toggle()} }) {
                    Image(systemName: "plus")
                }.frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .fileImporter(isPresented: .constant(viewModel.fileSelectionType == .upload), allowedContentTypes: viewModel.allowedFileType) { result in
            Task {
                withAnimation(.spring()) {showLoader.toggle()}
                await viewModel.importFile(result: result)
                withAnimation(.spring()) {showLoader.toggle()}
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
