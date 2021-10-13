//
//  HomeView.swift
//  easyselling
//
//  Created by Théo Tanchoux on 13/10/2021.
//

import SwiftUI

struct HomeView: View {
    @State var vehicles = [Vehicle]()
    
    var body: some View {
        List(vehicles) { vehicule in
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
        .onAppear() {
            VehicleService().getMockVehicles(token: "df") {
                (vehicles) in self.vehicles = vehicles
            }
        }.navigationTitle("User List")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
