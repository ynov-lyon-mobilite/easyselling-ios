//
//  SelectAppIcon.swift
//  easyselling
//
//  Created by Maxence on 07/12/2021.
//

import SwiftUI

struct SelectAppIcon: View {
    @AppStorage("AppIcon") private var selectedIcon: AppIcon = .defaultIcon

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(AppIcon.allCases, id: \.rawValue) { icon in
                Button(action: {
                    withAnimation {
                        selectedIcon = icon
                    }
                }) {
                    Image(icon.image)
                        .resizable()
                        .cornerRadius(10)
                        .frame(width: 65, height: 65)
                        .padding()
                        .background(selectedIcon == icon ? Color.gray : Color.clear)
                }
            }
        }
        .padding()
        .onChange(of: selectedIcon) { newIcon in
            UIApplication.shared.setAlternateIconName(newIcon.name)
        }
    }
}

private enum AppIcon: String, CaseIterable, Hashable {
    case defaultIcon = "AppIcon"
    case darkIcon = "DarkIcon"
    case orangeIcon = "OrangeIcon"

    var image: String {
        "\(rawValue)-Preview"
    }

    var name: String? {
        switch self {
        case .defaultIcon:
            return nil
        default:
            return rawValue
        }
    }
}

struct SelectAppIcon_Previews: PreviewProvider {
    static var previews: some View {
        SelectAppIcon()
    }
}
