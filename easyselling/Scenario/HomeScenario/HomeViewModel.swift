//
//  HomeViewModel.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 21/03/2022.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {

    @Published var selectedTabItem: TabItems = .profile

    func selectItem(_ tabItem: TabItems) {
        withAnimation {
            selectedTabItem = tabItem
        }
    }

    enum TabItems: String, CaseIterable, Hashable {
        case informations = "InformationsScenario"
        case vehicles = "VehicleScenario"
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
