//
//  SearchBar.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 30/03/2022.
//

import SwiftUI

struct SearchBar: View {

    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Asset.Colors.primary.swiftUIColor)

            TextField(L10n.Vehicles.SearchBar.placeholder, text: $searchText)
                .foregroundColor(Asset.Colors.primary.swiftUIColor)
                .overlay(
                    Button(action: { searchText = "" }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .padding()
                            .offset(x: 10)
                            .foregroundColor(Asset.Colors.primary.swiftUIColor)
                            .opacity(searchText.isEmpty ? 0 : 1)
                    }), alignment: .trailing
                )

        }
        .font(.headline)
        .padding()
        .background(
        RoundedRectangle(cornerRadius: 25)
            .fill(Asset.Colors.secondaryBackground.swiftUIColor)
        )
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchText: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}
