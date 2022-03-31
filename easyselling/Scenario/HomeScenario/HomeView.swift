//
//  HomeView.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 09/03/2022.
//

import SwiftUI

struct HomeView: View {

    @ObservedObject var viewModel: HomeViewModel
    var body: some View {
        VStack {
            VStack {
                switch viewModel.selectedTabItem {
                case .vehicles: VehicleScenarioViewInstantiator()
                case .profile: ProfileScenarioViewInstantiator(onLogout: viewModel.onLogout)
                default: Text("test")
                }
            }
            .edgesIgnoringSafeArea(.top)
            HStack(spacing: 100) {
                ForEach(HomeViewModel.TabItems.allCases, id: \.rawValue) { tabItem in
                    Button(action: { viewModel.selectItem(tabItem) }, label: {
                        VStack {
                            tabItem.image
                                .font(.title2)
                                .foregroundColor(viewModel.selectedTabItem == tabItem ? tabItem.imageColor : Color.gray)
                        }
                    })
                    .transition(.move(edge: .top))
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel(onLogout: {}))
    }
}
