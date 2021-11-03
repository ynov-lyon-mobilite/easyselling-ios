//
//  MyVehiclesView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 25/10/2021.
//

import SwiftUI

struct MyVehiclesView: View {
    
    @ObservedObject var viewModel: MyVehiclesViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                List(viewModel.vehicles) { vehicule in
                    VStack {
                        HStack {
                            Text("\(vehicule.brand)")
                            Text("\(vehicule.model)")
                            Spacer()
                            Text("\(vehicule.type.description)")
                        }
                        HStack {
                            Text("\(vehicule.license)")
                            Spacer()
                            Text("\(vehicule.year)")
                        }
                    }
                }
                
            }
        }
        .onAppear {
            Task {
                await viewModel.getVehicles()
            }
        }
        
    }
}

struct MyVehiclesView_Previews: PreviewProvider {
    static var previews: some View {
        MyVehiclesView(viewModel: MyVehiclesViewModel(isOpenningVehicleCreation: {}))
    }
}
