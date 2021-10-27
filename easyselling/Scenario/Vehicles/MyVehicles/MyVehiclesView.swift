//
//  MyVehiclesView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 25/10/2021.
//

import SwiftUI

struct MyVehiclesView: View {
    
    var viewModel: MyVehiclesViewModel
    
    var body: some View {
        Button(action: viewModel.openVehicleCreation) {
            Text("Ajouter un véhicule")
        }
    }
}

struct MyVehiclesView_Previews: PreviewProvider {
    static var previews: some View {
        MyVehiclesView(viewModel: MyVehiclesViewModel(isOpenningVehicleCreation: {}))
    }
}
