//
//  HomeViewModel.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 21/03/2022.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {

    init(onLogout: @escaping Action) {
        self.onLogout = onLogout
    }

    @Published var selectedTabItem: TabItems = .vehicles

    var onLogout: Action

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

        var imageColor: Color {
            switch self {
            case .informations: return Color.pink
            case .vehicles: return Asset.Colors.primary.swiftUIColor
            case .profile: return Asset.Colors.secondary.swiftUIColor
            }
        }
    }
}
