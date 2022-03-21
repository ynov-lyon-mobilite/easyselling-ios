//
//  TitleNavigationView.swift
//  easyselling
//
//  Created by Lucas Barthélémy on 16/02/2022.
//

import SwiftUI

struct TitleNavigationView: View {
    private let title: String
    private let color: Color

    init(color: Color = Asset.Colors.primary.swiftUIColor, title: String) {
        self.color = color
        self.title = title
    }

    var body: some View {
        Text(title)
            .foregroundColor(color)
            .fontWeight(.bold)
            .font(.system(size: 40))
    }
}

struct TitleNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        TitleNavigationView(title: "Préférences")
    }
}
