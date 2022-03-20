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
            switch viewModel.selectedTabItem {
            case .vehicles: VehicleScenarioViewInstantiator()
            case .profile: ProfileScenarioViewInstantiator()
            default: Text("test")
            }
            Spacer()
            HStack(spacing: 100) {
                ForEach(HomeViewModel.TabItems.allCases, id: \.rawValue) { tabItem in
                    Button(action: { viewModel.selectItem(tabItem) }, label: {
                        tabItem.image
                    })
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}

class HomeViewModel: ObservableObject {

    @Published var selectedTabItem: TabItems = .vehicles

    func selectItem(_ tabItem: TabItems) {
        selectedTabItem = tabItem
    }

    enum TabItems: String, CaseIterable, Hashable {
        case vehicles = "VehicleScenario"
        case informations = "InformationsScenario"
        case profile = "ProfileScenario"

        var image: Image {
            switch self {
            case .informations: return Image(systemName: "info.circle")
            case .vehicles: return Image(systemName: "car")
            case .profile: return Image(systemName: "person")
            }
        }
    }
}

struct VehicleScenarioViewInstantiator: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UINavigationController {
        return vehicleScenario()
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }

    private func vehicleScenario() -> UINavigationController {
        let navigationController = UINavigationController()
        let vehicleNavigator = DefaultVehicleNavigator(navigationController: navigationController)
        let vehicleScenario = VehicleScenario(navigator: vehicleNavigator)
        vehicleScenario.begin()

        return navigationController
    }
}

struct ProfileScenarioViewInstantiator: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UINavigationController {
        return profileScenario()
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }

    private func profileScenario() -> UINavigationController {
           let navigationController = UINavigationController()

           let profileNavigator = DefaultProfileNavigator(navigationController: navigationController, window: UIWindow())
           let profileScenario = ProfileScenario(navigator: profileNavigator)
           profileScenario.begin()

           return navigationController
       }
}
