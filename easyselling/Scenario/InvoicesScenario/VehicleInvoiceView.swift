//
//  VehicleInvoiceView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 24/11/2021.
//

import SwiftUI

struct VehicleInvoiceView: View {
    
    @ObservedObject var viewModel: VehicleInvoiceViewModel

    var body: some View {
        Text("Hello, World!")
    }
}

struct VehicleInvoiceView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleInvoiceView(viewModel: VehicleInvoiceViewModel())
    }
}
