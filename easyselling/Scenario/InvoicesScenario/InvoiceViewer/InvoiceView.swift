//
//  InvoiceView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 05/12/2021.
//

import SwiftUI

struct InvoiceView: View {

    @ObservedObject var viewModel: InvoiceViewerViewModel

    var body: some View {
        VStack {
            Image(uiImage: viewModel.invoiceFile.image)
                .resizable()
                .scaledToFit()
        }
        .navigationTitle(viewModel.invoiceFile.title)
    }
}

struct InvoiceView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceView(viewModel: InvoiceViewerViewModel(invoiceFile: File(title: "Facture échappement", image: UIImage(systemName: "person") ?? UIImage())))
    }
}
