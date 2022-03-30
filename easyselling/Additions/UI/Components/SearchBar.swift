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
            TextField("", text: $searchText)
                .placeholder(when: searchText.isEmpty, placeholder: {
                    Text("Cherchez un nom, modèle...").foregroundColor(Asset.Colors.primary.swiftUIColor)
                })
                .foregroundColor(Asset.Colors.primary.swiftUIColor)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundColor(Asset.Colors.primary.swiftUIColor)
                        .opacity(searchText.isEmpty ? 0 : 1)
                        .onTapGesture {
                            searchText = ""
                        }, alignment: .trailing
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
